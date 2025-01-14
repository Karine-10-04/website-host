.PHONY: all	

all:
	@echo "Use <make install> to install packages"
	@echo "Use <make build> to build docker images"

install:
	apt-get update 
	apt-get install -y docker-compose docker ca-certificates
	docker volume create --name=letsencrypt_keys
	touch nginx-lb/error.log
	touch nginx-www/www1-error.log
	touch nginx-www/www2-error.log
	touch nginx-webhook/error.log

	touch nginx-webhook/webhook.log
	
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
	cat crontab.t | envsubst >> ./crontab
	crontab ./crontab
	rm crontab
