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

build_app_for_env () {
  env=$( get_env_from_branch )
  echo "Building Android app for env $env"
  # For demo purpose, we always build an unsigned version of the app
  if [ "$env" == "$PROD_ENV" ]
  then
    # build_prod_android_app
    build_android_app
  else
    build_android_app
  fi
}

#
# Runtime
#
log_section "!Build Android app!"
build_app_for_env
