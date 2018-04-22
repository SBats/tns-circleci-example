#!/bin/bash

# sysinfo_page - Commons methods used in CI scripts

##################################################################
# Purpose: Log a new section to console
# Arguments:
#   $1 -> Section title
##################################################################
log_section () {
  echo "---------------"
  echo $1
  echo "---------------"
}

##################################################################
# Purpose: Build ios app with proper credentials
# Arguments:
#   $1 -> bundle id (ex: org.nativescript.circleciint)
##################################################################
build_ios_app () {
  profileUUID=$( $SCRIPT_PATH/get-provisioning-profile.js $1 Development )
  cd $CORE_PATH
  npx tns build ios --bundle --env.uglify --env.aot --forDevice --provision $profileUUID --copy-to "$BUILD_PATH/$IOS_IPA"
  cd $BASE_PATH
}

build_prod_ios_app () {
  profileUUID=$( $SCRIPT_PATH/get-provisioning-profile.js $1 Distribution )
  cd $CORE_PATH
  npx tns build ios --bundle --env.uglify --env.aot --forDevice --release --provision $profileUUID --copy-to "$BUILD_PATH/$IOS_IPA"
  cd $BASE_PATH
}

build_unsigned_ios_app () {
  cd $CORE_PATH
  npx tns build ios --bundle --env.uglify --env.aot
  cd $BASE_PATH
}

##################################################################
# Purpose: Build android app with proper credentials
##################################################################
build_android_app () {
  cd $CORE_PATH
  npx tns build android --bundle --env.uglify --env.aot --env.snapshot --copy-to "$BUILD_PATH/$ANDROID_APK"
  cd $BASE_PATH
}

##################################################################
# Purpose: Build android app with proper credentials
##################################################################
build_prod_android_app () {
  cd $CORE_PATH
  npx tns build android --bundle --env.uglify --env.aot --env.snapshot --copy-to "$BUILD_PATH/$ANDROID_APK" --release --keyStorePath "$KEYSTORE_PATH/$KEYSTORE_FILE" --keyStorePassword $KEYSTORE_PWD --keyStoreAlias $KEYSTORE_ALIAS --keyStoreAliasPassword $KEYSTORE_ALIAS_PWD
  cd $BASE_PATH
}

##################################################################
# Purpose: Return current env based on branch
# Rerturn: (PROD|DEV)
##################################################################
get_env_from_branch () {
  if [ "$CIRCLE_BRANCH" != "" ] && [ "$CIRCLE_BRANCH" == "master" ];
  then
    echo $PROD_ENV
  else
    echo $DEV_ENV
  fi
}

##################################################################
# Purpose: Return last commit message and comment
##################################################################
get_last_commit_message () {
  echo "$( git log -1 --pretty=%B | cat )"
}
