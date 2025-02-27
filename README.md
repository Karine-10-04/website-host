# karined-host

```bash
cp .env.example .env
vi .env

make install
make origin
make webhook-install
make webhook-test

cd www/src
ln -s ../../../website-config/ public

make build
docker-compose up -d
```

See Makefile
