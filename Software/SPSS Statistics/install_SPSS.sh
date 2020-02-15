#! /bin/bash

###################################################################################################
# Script Name:  install_SPSS.sh
# By:  Zack Thompson / Created:  11/1/2017
# Version:  1.5.1 / Updated:  1/27/2020 / By:  ZT
#
# Description:  This script silently installs SPSS.
#
###################################################################################################

echo "*****  Install SPSS process:  START  *****"

##################################################
# Define Variables

# Set working directory
pkgDir=$( /usr/bin/dirname "${0}" )
# Java JDK Directory
jdkDir="/Library/Java/JavaVirtualMachines"
# Version that's being updated (this will be set by the build_SPSS.sh script)
version=
majorVersion=$( echo $version | /usr/bin/awk -F "." '{print $1}' )

##################################################
# Bits staged...

echo "Checking for a JDK..."
if [[ ! -n $( /usr/bin/find "/Library/Java/JavaVirtualMachines" -iname "*.jdk" -type d ) ]]; then
	# Install prerequisite:  Java JDK
	echo "Installing prerequisite Java JDK from Jamf..."
	/usr/local/bin/jamf policy -event "Amazon_Corretto_JDK" -forceNoRecon
else
	echo "JDK exists...continuing..."
fi

# Make sure the Installer.bin file is executable
/bin/chmod +x "${pkgDir}/SPSS_Statistics_Installer.bin"

# Silent install using information in the installer.properties file
echo "Installing SPSS..."
exitStatus=$( "${pkgDir}/SPSS_Statistics_Installer.bin" -f "${pkgDir}/installer.properties" )
exitCode=$?

if [[ ! -d "/Applications/SPSS Statistics ${majorVersion}/SPSSStatistics.app" ]]; then
	echo "ERROR:  Install failed!"
	echo "Exit Code:  ${exitCode}"
	echo "ERROR Content:  ${exitStatus}"
	echo "*****  Install SPSS process:  FAILED  *****"
	exit 1
fi

echo "Install complete!"

# Setting permissions to resolve issues seen in:  https://www-01.ibm.com/support/docview.wss?uid=swg21966637
echo "Setting permissions on SPSS ${majorVersion} files..."
/usr/sbin/chown -R root:admin "/Applications/SPSS Statistics ${majorVersion}"

echo "*****  Install SPSS process:  COMPLETE  *****"
exit 0