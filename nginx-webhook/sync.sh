#!/bin/sh

cd /usr/share/nginx

git fetch origin-pat && git pull origin-pat main

LAST_COMMIT_ID=$(git log --format="%H" -n 1)

if ! grep -q $LAST_COMMIT_ID "/usr/share/nginx/last_commit_id"; then
    echo "Building $LAST_COMMIT_ID"
    cd www/
    npm ci 2>&1
    npm cache-clean --force 2>&1
    npm run build 2>&1
    echo $LAST_COMMIT_ID > /usr/share/nginx/last_commit_id
fi

echo "done"