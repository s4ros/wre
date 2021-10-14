#!/bin/bash

docker ps | grep 10000hmniejpl_db_1 &> /dev/null || (
    echo "10000hmniejpl_db_1 container is not running"
    exit 1
)
docker-compose exec db mysql -u wre -p"wre" wre
