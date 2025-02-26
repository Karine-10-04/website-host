#!/bin/sh

# set -x

BUILD_DIR="/usr/share/nginx"
WWW_DIR="$BUILD_DIR/www/src/public"

git -C $BUILD_DIR fetch --verbose origin-pat && \
    git -C $BUILD_DIR checkout $GITHUB_BRANCH_HOST && \
    git -C $BUILD_DIR pull --verbose origin-pat $GITHUB_BRANCH_HOST
LAST_COMMIT_ID=$(git -C $BUILD_DIR log --format="%H" -n 1)

git -C $WWW_DIR fetch --verbose origin-pat && \
    git -C $WWW_DIR checkout $GITHUB_BRANCH_WWW && \
    git -C $WWW_DIR pull --verbose origin-pat $GITHUB_BRANCH_WWW
LAST_WWW_COMMIT_ID=$(git -C $WWW_DIR log --format="%H" -n 1)

if ! grep -q $LAST_COMMIT_ID "$BUILD_DIR/last_commit_id"; then
    echo "NPM (re)install"
    npm ci --prefix $BUILD_DIR/www 2>&1
    npm cache-clean --force --prefix $BUILD_DIR/www 2>&1
fi

if ! grep -q $LAST_COMMIT_ID "$BUILD_DIR/last_commit_id" || ! grep -q $LAST_WWW_COMMIT_ID "$WWW_DIR/last_commit_id"; then
    echo "NPM (re)build"
    npm run --prefix $BUILD_DIR/www build 2>&1
    echo $LAST_COMMIT_ID > $BUILD_DIR/last_commit_id
    echo $LAST_WWW_COMMIT_ID > $WWW_DIR/last_commit_id
fi

echo "done"