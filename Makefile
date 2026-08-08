# Makefile - ai-agentos-bootstrap
# Primary operations:
#   make build-image   … build the cloud-init qcow2 template (Arch host, root)
#   make bootstrap     … minimal core install on a vanilla Arch VM
#   make provision     … Ansible self-apply (auto on first boot, or manual)
#   make packages      … add/remove OS packages only, on an existing VM
#   make ssh           … ssh into the VM (VM_HOST=<ip|hostname>)
#   make show-editable … list the files a user edits
#   make verify        … idempotency / reproducibility checks

.PHONY: help build-image bootstrap provision packages ssh show-editable verify

help:
	@echo "targets: build-image | bootstrap | provision | packages | ssh | show-editable | verify"
	@echo "  user-editable files are listed by: make show-editable"
	@echo "  ssh connects to the VM: make ssh VM_HOST=<ip|hostname>"

build-image:
	./cloud-init/build-image.sh

bootstrap:
	./bootstrap/bootstrap.sh

provision:
	ansible-playbook -i 'localhost,' ansible/site.yml

packages:
	ansible-playbook -i 'localhost,' ansible/site.yml --tags tools

ssh:
	@test -n "$(VM_HOST)" || (echo "usage: make ssh VM_HOST=<IP|hostname> (see docs/usage.md)" && exit 1)
	ssh -A $(VM_HOST)

show-editable:
	./scripts/show-editable-files.sh

verify:
	@echo "TODO(M4): CI idempotency / reproducibility checks"