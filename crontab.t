0 3 * * * docker-compose -f docker-compose-letsencrypt.yaml up
* * * * * sh $PWD/bin/sync-repo.sh > $PWD/bin/sync-repo.log 2>&1
