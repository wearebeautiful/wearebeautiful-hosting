#!/bin/bash

echo "---- WEAREBEAUTIFUL.INFO"

cd ../wearebeautiful-web
./stop-containers.sh
cd -

echo "---- STOP PROXY"
docker rm -f nginx le 

# echo "---- DONE"
