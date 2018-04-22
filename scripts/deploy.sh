#!/bin/bash

# sysinfo_page - TNS QA deployment script

#
# Variables
#
CURRENT_PATH=$( dirname "$0" ) # relative
CURRENT_PATH=$( cd $CURRENT_PATH && pwd ) # absolutized and normalized

#
# Load commons methods and variables
#
. "$CURRENT_PATH/commons.sh"
. "$CURRENT_PATH/config.sh"

#
# Methods
#

build_app () {
  env=$( get_env_from_branch )
  echo "Deploying for env $env"
  if [ "$env" == "$PROD_ENV" ]
  then
    /bin/bash "$SCRIPT_PATH/deploy_prod.sh"
  else
    /bin/bash "$SCRIPT_PATH/deploy_qa.sh"
  fi
}

#
# Runtime
#
log_section "!Deploying!"
build_app
