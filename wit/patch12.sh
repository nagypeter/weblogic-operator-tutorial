#!/bin/sh
#

CURRENT_DIR=$(pwd)

rm -Rf imagetool ../archive ../target
rm -f imagetool.zip weblogic-deploy.zip ../wdt-archive.zip

cd ../

#buils operator demo app
mvn clean package

mkdir -p archive/wlsdeploy/applications

cp target/opdemo.war archive/wlsdeploy/applications/

cd archive

jar cvf ../wdt-archive.zip *

cp ../wdt-archive.zip $CURRENT_DIR/

cd $CURRENT_DIR

# get the imagetool
curl -OL https://github.com/oracle/weblogic-image-tool/releases/latest/download/imagetool.zip
unzip imagetool.zip
export WIT_HOME=$(pwd)/imagetool

# get the deploy tool
curl -OL https://github.com/oracle/weblogic-deploy-tooling/releases/latest/download/weblogic-deploy.zip

$WIT_HOME/bin/imagetool.sh cache addInstaller \
  --path $(pwd)/weblogic-deploy.zip \
  --type wdt \
  --version latest

echo "Type MOS credentials user name:"
read SUPPORT_USER

echo "Type MOS credentials password:"
read -s SUPPORT_PASS

$WIT_HOME/bin/imagetool.sh update \
  --fromImage container-registry.oracle.com/middleware/weblogic:12.2.1.4 \
  --tag iad.ocir.io/weblogick8s/weblogic-operator-tutorial-store:12214-patched-mii-fromcontainer-1.0 \
  --user=$SUPPORT_USER \
  --password=$SUPPORT_PASS \
  --patches=32097167,32771440_12.2.1.4.201001 \
  --chown oracle:root \
  --wdtModelOnly \
  --wdtModel ./wdt-model.yaml \
  --wdtArchive ./wdt-archive.zip \
  --wdtVariables ./domain.properties \
  --wdtDomainType WLS


#  cleanup
cd $CURRENT_DIR
rm -Rf imagetool ../archive ../target
rm -f imagetool.zip weblogic-deploy.zip ../wdt-archive.zip
