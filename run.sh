#!/usr/bin/env bash

# The env; dev, prod, etc...
TF_ENV=$1

# The service name; network, data, compute, etc...
TF_SERVICE=$2

# Run from the location of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

if [ $# -gt 0 ]; then
    if [ ! -d "./$TF_ENV/$TF_SERVICE" ]; then
        echo "Directory $DIR/$TF_ENV/$TF_SERVICE does not exist."
        exit 1
    fi

    if [ "$3" == "init" ]; then
        terraform -chdir=./$TF_ENV/$TF_SERVICE init \
         -backend-config="bucket=terraform-state-amy" \
         -backend-config="key=$TF_ENV/$TF_SERVICE/terraform.tfstate"
    else
        terraform -chdir=./$TF_ENV/$TF_SERVICE $3
    fi
fi

# Return to the original location
cd -
