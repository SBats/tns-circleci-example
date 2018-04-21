#!/bin/bash

# sysinfo_page - Commons variables used in CI scripts

SCRIPT_PATH=$( dirname "$0" ) # relative
SCRIPT_PATH=$( cd $SCRIPT_PATH && pwd ) # absolutized and normalized
BASE_PATH="$SCRIPT_PATH/.."
#Keeping base and core separated if you want to have a sub-repo containing only your CI files
CORE_PATH="$BASE_PATH"
BUILD_PATH="$BASE_PATH/builds"
KEYSTORE_PATH="$BASE_PATH/keystores"
DEV_ENV="DEV"
PROD_ENV="PROD"
TIMESTAMP=$( date +"%s" )
ANDROID_APK="qa-mobile-$TIMESTAMP.apk"
IOS_IPA="qa-mobile-$TIMESTAMP.ipa"
IOS_ZIP="sauce-$CIRCLE_BRANCH.zip"
KEYSTORE_FILE="mysecret.keystore"
KEYSTORE_PWD="$KEYSTORE_PWD"
KEYSTORE_ALIAS="$KEYSTORE_ALIAS"
KEYSTORE_ALIAS_PWD="$KEYSTORE_ALIAS_PWD"
QA_EMAIL="$QA_EMAIL"
QA_PASSWORD="$QA_PASSWORD"
