#!/bin/bash

echo This file is a shell for automating a Splunk upgrade on the Cluster Manager
echo At any point in the upgrading process you can press Crtl-C to exit the script
echo
echo Do you wish to contine? yes/no
echo
read goCheck
if [ $goCheck = yes ]
then
	echo Continuing....
else
	exit
fi
echo
echo As part of the upgrade do you need to create a new directory for the backup? yes or no
echo
read directoryCheck
echo
if [ $directoryCheck = yes ]
then
	echo What is the name of your directory path?
	echo
	read directoryPath
        sudo mkdir $directoryPath
else
	echo Where are you going to store your backup?
	echo
	read directoryPath
	echo Your Splunk back will be stored in $directoryPath
fi
echo
echo What do you want your backup file to be called?
echo
read fileName
echo Where is you splunk directory located? Ex. "/opt/splunk"
echo
read splunkHome
echo $splunkHome
echo Preparing the backup
echo
echo Taking a backup of $splunkHome/etc
sudo tar -cvzf $directoryPath/$fileName.tgz $splunkHome/etc/apps/admin*
echo
echo Your back file is located under $directoryPath
ls -l $directoryPath
echo
echo What version of Splunk are you wanting to download?
echo
read splunkVersion
echo
echo What file type download do you want? tgz, rpm, etc...
echo
read splunkDownloadType
echo
content=$(wget https://www.splunk.com/en_us/download/previous-releases.html -q -O - | grep -E $splunkVersion.*$splunkDownloadType  )
echo
var1=$(echo "$content" | cut -d ',' -f5 | cut -d '"' -f6)
echo
var2=$( echo "$content" | cut -d ',' -f7 | cut -d '"' -f8)
echo
var3=$(echo "wget -O ${var1} \"${var2}\"")
echo Does the following command look right?
echo $var3
echo
echo yes/no
read downCheck
echo
if [ $downCheck = yes ]
then
	echo
	echo Downloading your Splunk content
	echo
	eval $var3
else
	echo What version of Splunk are you wanting to download?
	echo
	read splunkVersion
	echo
	echo What file type download do you want? tgz, rpm, etc...
	echo
	read splunkDownloadType
	echo
	content=$(wget https://www.splunk.com/en_us/download/previous-releases.html -q -O - | grep -E $splunkVersion.*$splunkDownloadType  )
	echo
	var1=$(echo "$content" | cut -d ',' -f5 | cut -d '"' -f6)
	echo
	var2=$( echo "$content" | cut -d ',' -f7 | cut -d '"' -f8)
	var3=$(echo "wget -O ${var1} \"${var2}\"")
fi
echo
echo Does the following command look right?
echo $var3
echo
echo yes/no
read downCheck
echo
if [ $downCheck = yes ]
then
        echo
        echo Downloading your Splunk content
        echo
        eval $var3
else
	echo Rethink your ability to do this Splunk Upgrade
fi
