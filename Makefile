# Reports — sync com o GitHub (conta dadossemcorrupcao).
# Uso: `make <alvo>`. Rode `make help` para a lista completa.

.DEFAULT_GOAL := help

# ── Git (conta dadossemcorrupcao) ──────────────────────────────────────────
# Mensagem do commit: passe com M="...". Ex.: make commit M="atualiza relatorio"
M ?=
# Este repo usa um alias SSH (github-empresa) que já aponta para a conta
# dadossemcorrupcao. O git-setup abaixo garante a identidade e o remote certos.
GH_HOST    := github-empresa
GH_ACCOUNT := dadossemcorrupcao
GH_REPO    := reports
REMOTE_URL := git@$(GH_HOST):$(GH_ACCOUNT)/$(GH_REPO).git

.PHONY: git-setup status commit push save pull sync
git-setup: ## Configura identidade + remote (conta dadossemcorrupcao via SSH) neste repo
	git config --local user.name "Dados Sem Corrupção"
	git config --local user.email "totens_carbono.5h@icloud.com"
	git remote set-url origin '$(REMOTE_URL)' 2>/dev/null || git remote add origin '$(REMOTE_URL)'
	@echo "✓ git configurado para a conta dadossemcorrupcao neste repositório"

status: ## Mostra o status do working tree
	git status

pull: ## Atualiza a partir do GitHub (origin main)
	git pull origin main

commit: ## Stage tudo e commita (uso: make commit M="mensagem")
	@test -n '$(M)' || { echo 'Erro: informe a mensagem. Ex.: make commit M="minha mensagem"'; exit 1; }
	git add -A
	git commit -m '$(M)'

push: ## Envia para o GitHub (origin, branch atual)
	git push origin HEAD

save: ## commit + push numa tacada (uso: make save M="mensagem")
	@$(MAKE) commit M='$(M)'
	@$(MAKE) push

sync: ## pull + commit + push (uso: make sync M="mensagem")
	@$(MAKE) pull
	@$(MAKE) save M='$(M)'

# ── Ajuda ──────────────────────────────────────────────────────────────────
.PHONY: help
help: ## Mostra esta ajuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
