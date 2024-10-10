.PHONY: all certs	

all:
	@echo "Use <make install> to install packages"


install:
	apt-get update
	apt-get install -y docker-compose docker

cert-cas:
	apt-get install -y ca-certificates

cert-key:
	[ -f ./certs/server.key ] && [ -f ./certs/server.crt ] && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./certs/server.key -out ./certs/server.crt	

cert-renewal:
	docker-compose -f docker-compose-letsencrypt.yaml up

cert-reload:
	docker-compose exec lb nginx -s reload

dev:
	apt-get install -y nodejs npm
	npm install -g vue-cli
