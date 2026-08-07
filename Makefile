# Makefile - ai-agentos-bootstrap
# Primary operations:
#   make build-image   … build the cloud-init qcow2 template (Arch host, root)
#   make bootstrap     … minimal core install on a vanilla Arch VM
#   make provision     … Ansible self-apply (auto on first boot, or manual)
#   make show-editable … list the files a user edits
#   make verify        … idempotency / reproducibility checks

.PHONY: help build-image bootstrap provision show-editable verify

help:
	@echo "targets: build-image | bootstrap | provision | show-editable | verify"
	@echo "  user-editable files are listed by: make show-editable"

build-image:
	./cloud-init/build-image.sh

bootstrap:
	./bootstrap/bootstrap.sh

provision:
	ansible-playbook -i 'localhost,' ansible/site.yml

show-editable:
	./scripts/show-editable-files.sh

verify:
	@echo "TODO(M4): CI idempotency / reproducibility checks"