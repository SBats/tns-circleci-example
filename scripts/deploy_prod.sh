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

send_to_production () {
  echo "---------------"
  echo "Uploading android apk"
  find $BUILD_PATH -type f -name "*.apk" -not -name ".DS_Store" -print0 | while read -r -d '' android_file_name
  do
    echo "$android_file_name"
    echo "$comment"
  done

  echo "---------------"
  echo "Uploading iOS ipa"
  find $BUILD_PATH -type f -name "*.ipa" -not -name ".DS_Store" -print0 | while read -r -d '' ios_file_name
  do
    echo "$ios_file_name"
    echo "$comment"
  done
}

#
# Runtime
#
log_section "!Sending to production!"
send_to_production
