#!/bin/sh
#

CURRENT_DIR=$(pwd)

rm -Rf imagetool ../archive ../target
rm -f imagetool.zip weblogic-deploy.zip ../wdt-archive.zip

# get the imagetool
curl -OL https://github.com/oracle/weblogic-image-tool/releases/latest/download/imagetool.zip
unzip imagetool.zip
export WIT_HOME=$(pwd)/imagetool

$WIT_HOME/bin/imagetool.sh cache listItems

#  cleanup
cd $CURRENT_DIR
rm -Rf imagetool ../archive ../target
rm -f imagetool.zip weblogic-deploy.zip ../wdt-archive.zip
