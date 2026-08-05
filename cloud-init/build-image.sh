#!/usr/bin/env bash
set -euo pipefail

# build-image.sh - build a cloud-init-enabled Arch Linux qcow2 template.
#
# Method: chroot/pacstrap (the arch-boxes approach) rather than running an
# installer inside a VM. Reproducible and composable.
#
# Result: a single qcow2 with GRUB (BIOS), an ext4 root, systemd-networkd,
# sshd and cloud-init enabled. First boot consumes user-data (user + SSH key +
# .env) from Proxmox / KVM and runs bootstrap.sh -> make provision.
#
# Requirements (RUN AS ROOT on a host with these):
#   arch-install-scripts, parted, dosfstools, qemu-utils (qemu-img),
#   and loop-device access. Run on an Arch host (pacstrap) or equivalent.
#
# Not runnable in unprivileged CI; validate against a live VM on a build host.

log() { printf '\033[1;34m[build-image]\033[0m %s\n' "$*"; }

OUT_IMG="${1:-arch-agent.qcow2}"
SIZE_MIB="${SIZE_MIB:-4096}"

ROOT_USER=0
if [ "$(id -u)" -ne "$ROOT_USER" ]; then
  echo "run as root (needs losetup, mount, pacstrap)" >&2
  exit 1
fi

for req in pacstrap arch-chroot genfstab parted mkfs.ext4 qemu-img losetup grub-install; do
  command -v "$req" >/dev/null 2>&1 || { echo "missing requirement: $req" >&2; exit 1; }
done

require_pkg() { pacman -Qi "$1" >/dev/null 2>&1 || { echo "missing pacman package: $1" >&2; exit 1; }; }
require_pkg arch-install-scripts

# --- workdir -------------------------------------------------------------
TMP="$(mktemp -d)"
trap 'umount "$TMP/mnt" 2>/dev/null || true; losetup -d "$LOOP" 2>/dev/null || true; rm -rf "$TMP"' EXIT

RAW="$TMP/root.raw"
MNT="$TMP/mnt"
mkdir -p "$MNT"

log "create raw image (${SIZE_MIB} MiB)"
truncate -s "${SIZE_MIB}M" "$RAW"
parted -s "$RAW" mklabel msdos mkpart primary ext4 1MiB 100% set 1 boot on

log "attach loop device"
LOOP="$(losetup --show -fP "$RAW")"
PART="${LOOP}p1"

log "format root partition"
mkfs.ext4 -q "$PART"

log "mount root"
mount "$PART" "$MNT"

log "pacstrap base system (this downloads packages)"
pacstrap -c "$MNT" \
  base linux linux-firmware \
  openssh cloud-init sudo python \
  systemd-networkd dhcpcd \
  grub

log "write fstab"
genfstab -U "$MNT" > "$MNT/etc/fstab"

# network for the chroot stage
cp /etc/resolv.conf "$MNT/etc/resolv.conf"

log "configure minimal system in chroot"
arch-chroot "$MNT" bash - <<'CONF'
set -e

# locale + timezone + hostname
cat > /etc/locale.conf <<EOF
LANG=en_US.UTF-8
EOF
cat >> /etc/locale.gen <<EOF
en_US.UTF-8 UTF-8
EOF
locale-gen >/dev/null
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
echo "ai-agent-vm" > /etc/hostname
cat >> /etc/hosts <<EOF
127.0.0.1   localhost
127.0.1.1   ai-agent-vm
EOF

# services
systemctl enable sshd cloud-init cloud-init-local cloud-init-config cloud-init-final \
  systemd-networkd systemd-resolved

# networkd DHCP on all ethernet interfaces
cat > /etc/systemd/network/20-wired.network <<EOF
[Match]
Name=e*

[Network]
DHCP=yes
EOF
CONF

log "install grub (BIOS) to the loop device"
grub-install --target=i386-pc --boot-directory="$MNT/boot" "$LOOP"

log "generate grub.cfg (fstab uses UUIDs)"
arch-chroot "$MNT" grub-mkconfig -o /boot/grub/grub.cfg

umount "$MNT"
losetup -d "$LOOP"

log "convert to qcow2: $OUT_IMG"
qemu-img convert -f raw -O qcow2 "$RAW" "$OUT_IMG"

log "done. import ${OUT_IMG} as a template, attach user-data:
  cloud-init/user-data.example.yml  (user + SSH key + .env)
  cloud-init/meta-data.example.yml  (hostname)"