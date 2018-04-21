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
upload_to_diawi () {
  # $1: file to upload (either an ipa or an apk)
  # $2: comment about app version/build
  jobInfos=$(curl https://upload.diawi.com/ -F token="$DIAWI_TOKEN" \
    -F file=@"$1" \
    -F wall_of_apps=0 \
    -F callback_emails="$QA_EMAIL" \
    -F password="$QA_PASSWORD" \
    -F comment="$2"
  )
  $SCRIPT_PATH/check-upload-status.js $DIAWI_TOKEN $jobInfos
}

get_app_comment () {
  cd $CORE_PATH
  comment=$( get_last_commit_message )
  cd $SCRIPT_PATH
  echo $comment
}

send_to_qa () {
  echo "Fetching last commit message"
  comment=$( get_app_comment )

  echo "---------------"
  echo "Uploading android apk"
  find $BUILD_PATH -type f -name "*.apk" -not -name ".DS_Store" -print0 | while read -r -d '' android_file_name
  do
    echo "$android_file_name"
    echo "$comment"
    # upload_to_diawi $android_file_name "$comment"
  done

  echo "---------------"
  echo "Uploading iOS ipa"
  find $BUILD_PATH -type f -name "*.ipa" -not -name ".DS_Store" -print0 | while read -r -d '' ios_file_name
  do
    echo "$ios_file_name"
    echo "$comment"
    # upload_to_diawi $ios_file_name "$comment"
  done
}

#
# Runtime
#
log_section "!Sending to QA!"
send_to_qa
