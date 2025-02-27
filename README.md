# karined-host

```bash
cd www/src
ln -s ../../../website-config/ public

cp .env.example .env
vi .env

make install
make origin
make webhook-install
make webhook-test

make build
docker-compose up -d
```

See Makefile
