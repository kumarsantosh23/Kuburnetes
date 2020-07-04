#!/bin/bash
cd /home/cw22hn2/scripts/
SOURCE='fepp-cdhdn-d2.fepoc.com'
LOG=' solr-cmf-solr-SOLR_SERVER-fepp-cdhdn-d2.fepoc.com.log.out'
DIRECTORY='/home/cw22hn2/scripts'
TXTMESSAGE='PerGen Error had occured in '$SOURCE' '$LOG
REENABLE=`date +%s`
#time til twilio can make a telephone call to admin again.
CALLCOOLDOWN=`date +%s`
#1 means enable checking for the following types of error: Fatal, NullPointer, PermGen
CERROR=1
#Slack webhook
tail -Fn0 $LOG | \
while read line; do
#####
        if [ $CERROR = 1 ]
        then
                TYPE='ERROR'
                echo "$line" | grep  -q "$TYPE"
                if [ $? = 0 ]
                then
                        tac $LOG | grep  -m 1 -B 5 -A 1 $TYPE > snippetb
#                        tac snippetb > snippet
                        message=$(<snippetb)
                        echo "$message" | mailx -r nagarjuna.merapala@fepoc.com  -v -s "$SOURCE Disconnected from Solr" "$TYPE" "nagarjuna.merapala@fepoc.com"
                        now=`date +%Y-%m-%d`
#                        cat snippet >> $DIRECTORY/$TYPE$now
                fi
        fi
#####
done
