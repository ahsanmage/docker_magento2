#!/bin/bash

#####	#####	#####
##### GIT SETTINGS
#####	#####	#####
#GIT_TAG_VER=`git describe --exact-match --tags $(git log -n1 --pretty='%h')`
#GIT_CHECKOUT_HASH=`git log --pretty=format:'%h' -n 1`
#GIT_BRANCH=`git rev-parse --symbolic-full-name --abbrev-ref HEAD`
#GIT_COMMIT_HASH=`git rev-parse --short HEAD`
#GIT_TAG_URL="https://bitbucket.org/sssports/upgrade-2.1.6/commits/tag/"
#GIT_COMMIT_URL="https://bitbucket.org/sssports/upgrade-2.1.6/commits/"
#GIT_BRANCH_URL="https://bitbucket.org/sssports/upgrade-2.1.6/commits/branch/"



#####	#####	#####
##### SLACK SETTINGS
#####	#####	#####
#SLACK_API_URL="https://hooks.slack.com/services/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"
#CHANNEL_NAME="@ahsansss"
ENV_URL="Environment: http://local.sssports.com:8090"


#####	#####	#####
##### GIT AND SLACK CONDITIONALS
#####	#####	#####
#if [[ -z "$GIT_TAG_VER" ]]
#then
#    GIT_TAG_MSG=""
#else
#    GIT_TAG_MSG='Latest Tag: <'"$GIT_TAG_URL$GIT_TAG_VER"'|'"$GIT_TAG_VER"'>\n'
#fi
#if [[ -z "$GIT_CHECKOUT_HASH" ]]
#then
#    GIT_COMMIT_MSG=""
#else
#    GIT_COMMIT_MSG='Latest Commit: <'"$GIT_COMMIT_URL$GIT_CHECKOUT_HASH"'|'"$GIT_CHECKOUT_HASH"'>\n'
#fi
#if [[ -z "$GIT_BRANCH" ]]
#then
#    GIT_BRANCH_MSG=""
#else
#    GIT_BRANCH_MSG='Current Branch: <'"$GIT_BRANCH_URL$GIT_BRANCH"'|'"$GIT_BRANCH"'>\n'
#fi

#####	#####	#####
##### START DEPLOYMENT
#####	#####	#####

curl -X POST --data-urlencode 'payload={"channel": "'"$CHANNEL_NAME"'", "text": "*DEV STARTED*\n'"$GIT_TAG_MSG$GIT_COMMIT_MSG$GIT_BRANCH_MSG"'", "icon_emoji": ":sss-dev-team:"}' $SLACK_API_URL

cd /var/www/html/
echo -e ""
START_TIME=`date +%s`
## TURN OFF MAGENTO
php -f ./bin/magento maintenance:enable
## REMOVE VAR FOLDERS
rm -rf var/di/* var/generation/* var/cache/* var/page_cache/* var/view_preprocessed/* pub/static/_requirejs/* pub/static/frontend/sss/default/* pub/static/frontend/sss/arabic/*
rm -rf pub/assets/*
## STATIC BUILDER
( cd /var/www/html/app/design/frontend/sss/staticapp ; gulp copy sprites styles fonts scripts imgs sssjs ssscss )
grunt clean
grunt exec:sss_default
grunt exec:sss_arabic
cd /var/www/html/
php -f ./bin/magento setup:upgrade
php -f ./bin/magento cache:clean
php -f ./bin/magento setup:static-content:deploy --theme Magento/backend
php -f ./bin/magento setup:static-content:deploy --theme sss/default
php -f ./bin/magento setup:static-content:deploy --theme sss/arabic ar_SA
## COMPILE AND FINALISE MAGENTO
php -f ./bin/magento setup:di:compile
php -f ./bin/magento maintenance:disable
## RESTART VARNISH
#sudo service varnish restart
php -f ./bin/magento cache:clean
php -f ./bin/magento cache:flush
#####	#####	#####
##### END DEPLOYMENT
#####	#####	#####

END_TIME=`date +%s`
DIFF_TIME=$((END_TIME-START_TIME))
DIFF_TIME_STR="Tasktime: "$(($DIFF_TIME/60))' min, '$(($DIFF_TIME%60))' sec\n'
curl -X POST --data-urlencode 'payload={"channel": "'"$CHANNEL_NAME"'", "text": "*DEV FINISHED*\n'"$GIT_TAG_MSG$GIT_COMMIT_MSG$GIT_BRANCH_MSG$DIFF_TIME_STR$ENV_URL"'", "icon_emoji": ":sss-dev-team:"}' $SLACK_API_URL
echo -e ""