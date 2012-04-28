#!/bin/sh

TMPz=`pwd`/`dirname $0`
APP_HOME=`echo $TMPz | sed s:/bin::`


echo message is:
. $APP_HOME/conf/setenv.sh

echo "Hi $MESSAGE"
