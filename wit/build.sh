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


# check jdk installer
JDK_INSTALLER=jdk-8u291-linux-x64.tar.gz
if [ -f "$JDK_INSTALLER" ]; then
    echo "$JDK_INSTALLER exists."
else
    echo "$JDK_INSTALLER does not exist. Download from https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html"
fi

# check weblogic installer
WLS_INSTALLER=fmw_14.1.1.0.0_wls_lite_slim_Disk1_1of1.zip
if [ -f "$WLS_INSTALLER" ]; then
    echo "$WLS_INSTALLER exists."
else
    echo "$WLS_INSTALLER does not exist. Download from https://www.oracle.com/de/middleware/technologies/fusionmiddleware-downloads.html"
fi

$WIT_HOME/bin/imagetool.sh cache addInstaller \
  --path $(pwd)/jdk-8u291-linux-x64.tar.gz \
  --type jdk \
  --version 8u291

$WIT_HOME/bin/imagetool.sh cache addInstaller \
  --path $(pwd)/fmw_14.1.1.0.0_wls_lite_slim_Disk1_1of1.zip \
  --type wls \
  --version 14.1.1.0.0

$WIT_HOME/bin/imagetool.sh cache addInstaller \
  --path $(pwd)/weblogic-deploy.zip \
  --type wdt \
  --version latest

$WIT_HOME/bin/imagetool.sh create \
  --tag iad.ocir.io/weblogick8s/weblogic-operator-tutorial-store:14.1.1-psu \
  --version 14.1.1.0.0 \
  --jdkVersion 8u291 \
  --chown=oracle:root \
  --recommendedPatches \
  --patches=32097167 \
  --user=peter.nagy@oracle.com \
  --passwordEnv=SUPPORT_PASS \
  --wdtModelOnly \
  --wdtModel ./wdt-model.yaml \
  --wdtArchive ./wdt-archive.zip \
  --wdtVariables ./domain.properties

#  cleanup
cd $CURRENT_DIR
rm -Rf imagetool ../archive ../target
rm -f imagetool.zip weblogic-deploy.zip ../wdt-archive.zip
