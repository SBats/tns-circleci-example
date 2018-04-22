#!/bin/bash

# sysinfo_page - TNS QA deployment script

#
# Variables
#
BUNDLE_ID="$1"
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
  echo "Building iOS app for env $env"
  # For demo purpose, we build an unsigned ipa as we don't have a matching iTunes Connect account
  if [ "$env" == "$PROD_ENV" ]
  then
    # build_prod_ios_app $BUNDLE_ID
    build_unsigned_ios_app
  else
    # build_ios_app $BUNDLE_ID
    build_unsigned_ios_app
  fi
}

#
# Runtime
#
log_section "!Build iOS app!"
build_app
