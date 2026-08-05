# Makefile - ai-agentos-bootstrap
# Primary operations:
#   make build-image   … build the cloud-init qcow2 template (M1)
#   make bootstrap     … minimal core install on a vanilla Arch VM (M2)
#   make provision     … Ansible self-apply (auto on first boot, or manual)
#   make verify        … idempotency / reproducibility checks (M4)

.PHONY: build-image bootstrap provision verify

build-image:
	./cloud-init/build-image.sh

bootstrap:
	./bootstrap/bootstrap.sh

provision:
	ansible-playbook -i 'localhost,' ansible/site.yml

verify:
	@echo "TODO(M4): CI idempotency / reproducibility checks"
