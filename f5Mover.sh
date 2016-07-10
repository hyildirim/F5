#!/bin/sh
# Created by Luke Yildirim [luke.yildirim@rackspace.com]
# ----------------------------------------------------------------------------------------------
# DISCLAIMER: USE IT AT YOUR OWN RISK
# ----------------------------------------------------------------------------------------------
# This set of scripts make serious changes to your F5 configuration

DATE=`date +%Y-%m-%d`

echo "INFO: Saving current configuration to /var/local/ucs/beforeMaintenance-$DATE.ucs"
tmsh save sys ucs /var/local/ucs/beforeMaintenance-$DATE.ucs
BACKUPDIR="/root/configBackups/$DATE";


if [ ! -d $BACKUPDIR ]; then
        mkdir -p $BACKUPDIR
        echo "Creating backup directory $BACKUPDIR"
fi

echo "INFO: Saving important configuration files [/config/*.conf] to $BACKUPDIR"
cp /config/*.conf $BACKUPDIR
if [ -d "/config/partitions" ]; then
        echo "Copying partition configs to $BACKUPDIR"
        cp -R /config/partitions $BACKUPDIR
fi



#tmsh save sys ucs beforeMaintenance-$DATE.ucs

# This is where you can do your excludes or simply edit customerConfiguration.conf file and
# delete the object that you don't want moved.
echo "INFO: Exporting all virtual objects under /Common"
tmsh list ltm virtual one-line | grep -v FORWARDING > /shared/tmp/customerConfiguration.conf


# get all customer pools
echo "INFO: Exporting all pool objects under /Common"
tmsh list ltm pool one-line >> /shared/tmp/customerConfiguration.conf

# get all nodes
echo "INFO: Export all node objects under /Common"
tmsh list ltm node one-line >> /shared/tmp/customerConfiguration.conf

echo "INFO: Downloading the script from github"
curl -o /root/f5PartitionMover.pl -s https://raw.githubusercontent.com/hyildirim/F5/master/f5PartitionMover.pl
curl -o /root/f5ApplyChanges.pl -s https://raw.githubusercontent.com/hyildirim/F5/master/f5ApplyChanges.pl

echo "INFO: Script was saved under /root/f5PartitionMover.pl"
echo "INFO: Examine /shared/tmp/customerConfiguration.conf VERY CAREFULLY and EDIT if necessary"
echo "INFO: if you would like to exclude certain objects from being moved to another partition"
echo "INFO: when ready, execute perl /root/f5PartitionMover.pl /shared/tmp/customerConfiguration.conf"
echo "INFO: This will generate the changes under /root/newCustomerConfig.txt"
echo "INFO: Examine the configuration changes"
echo "INFO: When ready execute f5MoveObjects.pl /root/newCustomerConfig.txt"
