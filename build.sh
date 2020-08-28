#!/bin/bash

echo "---- wearebeautiful-logs"
docker build -f Dockerfile.logging -t wearebeautiful-logs .

echo "---- wearebeautiful-web"

cd ../wearebeautiful-web
./build.sh
cd -

echo "---- DONE"
