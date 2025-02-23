include .env
.PHONY: all

all:
	@echo "Use <make install> to install packages"
	@echo "Use <make origin> to git remote set-url origin-pat"
	@echo "Use <make build> to build docker images"
	@echo "Use <make cert-key> to generate new key and crt with openssl"
	@echo "Use <make cert-renewal> to renew the certificate with certbot"
	@echo "Use <make cert-reload> to gracefully reload nginx"
	@echo "Use <make crontab> to install the crontab"
	@echo "Use <make sync> to sync with host/www repositories and rebuild"
	@echo "Use <make webhook-test> to list the webhooks"
	@echo "Use <make webhook-delete to remove the webhooks"
	@echo "Use <make webhook-install> to install the webhooks"

install:
	apt-get update
	apt-get install -y docker-compose docker ca-certificates git jq
	docker volume create --name=letsencrypt_keys
	cp -n .env.example .env

origin:
	export $(grep -v '^#' .env | xargs)
	git remote --verbose add origin-pat https://${GITHUB_PAT_HOST}@github.com/${GITHUB_REPO_HOST}.git || \
		git remote --verbose set-url origin-pat https://${GITHUB_PAT_HOST}@github.com/${GITHUB_REPO_HOST}.git
	git -C www/src/public/ remote --verbose add origin-pat https://${GITHUB_PAT_WWW}@github.com/${GITHUB_REPO_CONFIG}.git || \
		git -C www/src/public/ remote --verbose set-url origin-pat https://${GITHUB_PAT_WWW}@github.com/${GITHUB_REPO_CONFIG}.git

build:
	DOCKER_BUILDKIT=1 docker build -f nginx-webhook/Dockerfile.nginx-debian -t base-image:nginx-debian --build-arg ENABLED_MODULES="ndk lua" .
	DOCKER_BUILDKIT=1 docker build -f nginx-webhook/Dockerfile.webhook -t base-image:webhook .

cert-key:
	[ -f ./certs/server.key ] && [ -f ./certs/server.crt ] && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./certs/server.key -out ./certs/server.crt

cert-renewal:
	docker-compose -f docker-compose-letsencrypt.yaml up

cert-reload:
	docker-compose exec lb nginx -s reload

crontab:
	cat crontab.template | envsubst >> ./crontab
	crontab ./crontab
	rm crontab

sync:
	docker exec -it $$(docker ps --format "{{.Names}}" | grep webhook) bash /usr/local/bin/sync.sh

HOOK_ID_HOST := $(shell curl -s -L -H "Authorization: Bearer ${GITHUB_PAT_HOST}" https://api.github.com/repos/${GITHUB_REPO_HOST}/hooks | jq '.[0].id')
HOOK_ID_WWW := $(shell curl -s -L -H "Authorization: Bearer ${GITHUB_PAT_WWW}" https://api.github.com/repos/${GITHUB_REPO_WWW}/hooks | jq '.[0].id')

webhook-test:
	curl -s -L \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer ${GITHUB_PAT_HOST}" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		https://api.github.com/repos/${GITHUB_REPO_HOST}/hooks \
	| jq '.'

	curl -s -L \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer ${GITHUB_PAT_WWW}" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		https://api.github.com/repos/${GITHUB_REPO_WWW}/hooks \
	| jq '.'

webhook-delete:
ifneq ($(HOOK_ID_HOST),null)
	curl -L \
		-X DELETE \
		-H "Authorization: Bearer ${GITHUB_PAT_HOST}" \
		https://api.github.com/repos/${GITHUB_REPO_HOST}/hooks/${HOOK_ID_HOST} \
		-d '{"name":"web","active":true,"events":["push"],"config":{"url":"${GITHUB_WEBHOOK_URL}","content_type":"json","insecure_ssl":"1","secret": "${GITHUB_WEBHOOK_SECRET}"}}'
endif
ifneq ($(HOOK_ID_WWW),null)
	curl -L \
		-X DELETE \
		-H "Authorization: Bearer ${GITHUB_PAT_WWW}" \
		https://api.github.com/repos/${GITHUB_REPO_WWW}/hooks/${HOOK_ID_WWW} \
		-d '{"name":"web","active":true,"events":["push"],"config":{"url":"${GITHUB_WEBHOOK_URL}","content_type":"json","insecure_ssl":"1","secret": "${GITHUB_WEBHOOK_SECRET}"}}'
endif

webhook-install:
ifeq ($(HOOK_ID_HOST),null)
	curl -L \
		-X POST \
		-H "Authorization: Bearer ${GITHUB_PAT_HOST}" \
		https://api.github.com/repos/${GITHUB_REPO_HOST}/hooks \
		-d '{"name":"web","active":true,"events":["push"],"config":{"url":"${GITHUB_WEBHOOK_URL}","content_type":"json","insecure_ssl":"1","secret": "${GITHUB_WEBHOOK_SECRET}"}}'
else
	curl -L \
		-X PATCH \
		-H "Authorization: Bearer ${GITHUB_PAT_HOST}" \
		https://api.github.com/repos/${GITHUB_REPO_HOST}/hooks/${HOOK_ID_HOST} \
		-d '{"name":"web","active":true,"events":["push"],"config":{"url":"${GITHUB_WEBHOOK_URL}","content_type":"json","insecure_ssl":"1","secret": "${GITHUB_WEBHOOK_SECRET}"}}'
endif
ifeq ($(HOOK_ID_WWW),null)
	curl -L \
		-X POST \
		-H "Authorization: Bearer ${GITHUB_PAT_WWW}" \
		https://api.github.com/repos/${GITHUB_REPO_WWW}/hooks \
		-d '{"name":"web","active":true,"events":["push"],"config":{"url":"${GITHUB_WEBHOOK_URL}","content_type":"json","insecure_ssl":"1","secret": "${GITHUB_WEBHOOK_SECRET}"}}'
else
	curl -L \
		-X PATCH \
		-H "Authorization: Bearer ${GITHUB_PAT_WWW}" \
		https://api.github.com/repos/${GITHUB_REPO_WWW}/hooks/${HOOK_ID_WWW} \
		-d '{"name":"web","active":true,"events":["push"],"config":{"url":"${GITHUB_WEBHOOK_URL}","content_type":"json","insecure_ssl":"1","secret": "${GITHUB_WEBHOOK_SECRET}"}}'
endif