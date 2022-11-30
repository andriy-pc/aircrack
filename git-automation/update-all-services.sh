#!/bin/bash
# The script is for pulling all the services. To not lose your changes it does stash
# To make this script work, all the services should be in the same root folder 

stash() {
    git stash -m "Brach: [$(git rev-parse --abbrev-ref HEAD)]. Date: [$(date +'%d_%m_%Y')]"
}

checkout_dev() {
    git checkout dev
}

pull_dev() {
    git pull origin dev
}

for path in $(ls .);
do
    cd $path
    stash
    checkout_dev
    pull_dev
    cd ..
done