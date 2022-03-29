#!/usr/bin/env bash

# The env; dev, prod, etc...
TF_ENV=$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Run from the location of this script
cd $DIR

if [ $# -gt 0 ]; then
    if [ "$2" == "init" ]; then
        terraform -chdir=./$TF_ENV init -backend-config=../backend-$TF_ENV.tf
    else
        terraform -chdir=./$TF_ENV $2
    fi
fi

# Return to the original location
cd -