# Makefile - ai-agentos-bootstrap
# 主な操作:
#   make build-image   … qcow2 テンプレ生成 (M1 実装予定)
#   make provision     … Ansible self-apply (ログイン後に実行, M3 実装予定)
#   make verify        … 冪等・再現性検証 (M4 実装予定)

.PHONY: build-image provision verify

build-image:
	./cloud-init/build-image.sh

provision:
	ansible-playbook -i 'localhost,' ansible/site.yml

verify:
	@echo "TODO(M4): CI 冪等・再現性検証"
