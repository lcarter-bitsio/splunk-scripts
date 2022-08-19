# Splunk Enterprise Upgrade

The following article is a generic Splunk step-by-step guide to upgrading your Splunk Enterprise environment. The links below are important to consult before starting your upgrade. Knowing what version of Splunk you are running is also important to planning your upgrade. Certain updates could require two version updates to get to the most current version of Splunk.

<a href="https://docs.splunk.com/Documentation/Splunk/9.0.0/Installation/HowtoupgradeSplunk"> Splunk Upgrade Documentation</a>
<a href="https://docs.splunk.com/Documentation/Splunk/9.0.0/Installation/UpgradeyourdistributedSplunkEnterpriseenvironment"> Splunk Distributed Environment Upgrade Documentation</a>
<a href="https://docs.splunk.com/Documentation/Splunk/9.0.0/Indexer/Upgradeacluster"> Splunk Indexer Cluster Upgrade Documentation</a>
<a href="https://docs.splunk.com/Documentation/Splunk/9.0.0/DistSearch/UpgradeaSHC"> Splunk Search Head Upgrade Documentation</a>

# Initial Set Up

Once you've determined what version of Splunk you are running and the upgrade path you are taking. You will need the download for the version of Splunk. The link below takes you to the most current Splunk download. However, if you wish to upgrade to a different version you can use the "Older Releases" tab to find the version you are looking for.
 
<a href="https://www.splunk.com/en_us/download/splunk-enterprise.html?locale=en_us">Splunk Enterprise Downloads</a>
<a href="https://www.splunk.com/en_us/download/previous-releases.html">Splunk Enterprice Downloads - Older Releases</a>

Plan on taking a backup of your **$SPLUNK_HOME/etc/** to the directory of your choice. Ensure that there is enough space on that directory to accommodate the backup. An example command can the found below. The first path after the "-cvf" is the path of storage and the second path is the location of the directory you wish to back up. The Splunk service should be stopped before backing up the /etc/ directory. ***This should be done on every host before starting the upgrade!***
```
tar -cvf /tmp/splunk_clusterManagerApps.tgz /opt/splunk/etc/
``` 
## List of Splunk Server Upgrade by Server Type
1. Cluster Manager
2. Monitoring Console
3. Search Heads
4. Indexers
5. Heavy Forwarder

## Cluster Manager Upgrade

Login to you Cluster Manager console and follow those backup steps prior to beginning the upgrade. You will need to use an account that has proper permission to perform the upgrade end-to-end

#### Stop the Splunk service
```
/opt/splunk/bin/splunk/stop
```
 #### Backup all the Splunk configs
 This will include all files in /etc/system and /etc/apps. Be aware that /tmp will have additional permission than creating a directory specifically for the back.
```
tar -cvf /tmp/splunk_clusterManagerApps.tgz /opt/splunk/etc/
```
 #### Download your version of Splunk 
 Splunk provides the command below that you can put in the console.
 It is a good idea to navigate to the location where the download should be stored
```
wget -O splunk-9.0.0.1-9e907cedecb1-linux-2.6-x86_64.rpm "https://download.splunk.com/products/splunk/releases/9.0.0.1/linux/splunk-9.0.0.1-9e907cedecb1-linux-2.6-x86_64.rpm"
```
 If you get an error that wget is not installed the following command should be able to get it installed. The "-y" accepts the install so there is no manual acceptance to download it
```
yum -y install wget
```
#### Extract the rpm download
Because this is an upgrade, nothing needs to be uninstalled and reinstalled. The rpm file can be placed anywhere and the following command can be run to install the upgrade.
```
rpm -Uvh splunk-9.0.0.1-9e907cedecb1-linux-2.6-x86_64.rpm
```
#### Start the Splunk service
Now that the update is applied the Splunk service can be started again.
```
/opt/splunk/bin/splunk start --accept-license --answer-yes
```


## Monitoring Console Upgrade

The steps above can be repeated to update the Monitoring Console

## Search Head Cluster Upgrade

We can do a peer by peer upgrade. Taking one search head down at a time to allow for some search functionally during the upgrade time. The steps are the exact same as above. 
1.	Stop the Splunk Service
2.	Take a back up
3.	Download the new Splunk version
4.	Extract the version
5.	Start the Splunk service

## Upgrading the Indexers

Before starting the indexer upgrading it is imperative that the Cluster Manager be put in **Maintenance Mode**. This step prevents unnecessary bucket fix-ups during the upgrade.

#### On the CM - run the following command as the Splunk user
```
/opt/splunk/bin/splunk enable maintenance-mode
```
#### Check the Status of Maintenance Mode
```
/opt/splunk/bin/splunk show maintenance-mode
```
Once the Cluster Manager is confirmed to be in maintenance mode, proceed with the upgrade process on a peer by peer basis. 

#### Splunk Indexer - Offline
Use the following command to stop the Splunk service. 
```
/opt/splunk/bin/splunk offline
```
This ensures that whatever the indexer is currently working on is completed in a way that minimizes disruptions to searchable data.
Follow the steps repeated on the other peers for the upgrade process. Once all the indexers are updated, the Cluster Manage needs to be taken off maintenance mode

#### On CM - Disable Maintenance Mode
```
/opt/splunk/bin/splunk disable maintenance-mode
```
#### Check the Status of Maintenance Mode
```
/opt/splunk/bin/splunk show maintenance-mode
```

## Upgrading Deployer
Follow the upgrade steps like the other Splunk hosts

1.	Stop the Splunk Service
2.	Take a back up
3.	Download the new Splunk version
4.	Extract the version
5.	Start the Splunk service

## Upgrading Heavy Forwarder
Follow the upgrade steps like the other Splunk hosts
1.	Stop the Splunk Service
2.	Take a back up
3.	Download the new Splunk version
4.	Extract the version
5.	Start the Splunk service
