#!/bin/bash
## Requires :
# - docker, docker-compose (v1+) : sudo apt install docker docker-compose
set -x # debug mode
set -e # exit when any command fails

printArguments() {
    echo "Usage : sh start.sh [argument]"
    echo " init            Initialize the project."
}

init() {
    docker-compose down --rmi all --volumes --remove-orphans
    docker-compose up -d
    cd ./ApiWithAuth
    killall dotnet || true
    migrate
    dotnet run &
    logs
}

installef() {
    dotnet tool install --global dotnet-ef
}

makemigrations() {
    installef
    dotnet ef migrations add migrationMsg
}

migrate() {
    installef
    dotnet ef database update
}

logs() {
    docker-compose logs -ft
}

main() {
    if [ $# -eq 0 ]; then
        set +x # disable debug mode for pretty print
        printArguments
        exit 1
    fi

    if [ ! -f .env ]; then
        echo ".env not found"
        cp .env.tpl .env
    fi
    source ./.env

    cmd="$1 ${@:2}" # $1 is the command and ${@:2} is the list of arguments
    $cmd
}

main $@
