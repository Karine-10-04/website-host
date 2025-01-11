.PHONY: all certs	

all:
	@echo "Use <make install> to install packages"


install:
	apt-get update
	apt-get install -y docker-compose docker ca-certificates nodejs npm
	docker volume create --name=letsencrypt_keys
	touch lb-error.log
	touch www1-error.log
	touch www2-error.log
	npm install -g vue-cli
	npm --prefx ./www install

cert-key:
	[ -f ./certs/server.key ] && [ -f ./certs/server.crt ] && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./certs/server.key -out ./certs/server.crt	

cert-renewal:
	docker-compose -f docker-compose-letsencrypt.yaml up

cert-reload:
	docker-compose exec lb nginx -s reload

www-reload:
	npm --prefix ./www run build

cron:
	cp -f $(CURDIR)/crontab /var/spool/cron/crontabs/root