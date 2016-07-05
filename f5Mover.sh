#!/bin/sh
# Created by Luke Yildirim [luke.yildirim@rackspace.com]
# ----------------------------------------------------------------------------------------------
# DISCLAIMER: USE IT AT YOUR OWN RISK
# ----------------------------------------------------------------------------------------------
# This set of scripts make serious changes to your F5 configuration

DATE=`date +%Y-%m-%d`

echo "INFO: Saving current configuration to /var/local/ucs/beforeMaintenance-$DATE.ucs"

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

echo "INFO: Downloading f5PartitionMover script from github"
curl -o /root/f5PartitionMover.pl -s https://raw.githubusercontent.com/hyildirim/F5/master/f5PartitionMover.pl

echo "INFO: Downloading f5MoveObjects script from github"
curl -o /root/f5MoveObjects.pl -s https://raw.githubusercontent.com/hyildirim/F5/master/f5MoveObjects.pl

echo "INFO: Script was saved under /root/f5PartitionMover.pl"
echo "INFO: Scrtip was saved under root/f5MoveObjects.pl"


echo "---------------------------------------------------------------------------------------------"
echo "INFO: Examine /shared/tmp/customerConfiguration.conf VERY CAREFULLY and EDIT if necessary"
echo "INFO: if you would like to exclude certain objects from being moved to another partition"
echo "---------------------------------------------------------------------------------------------"
echo "INFO: when ready, execute perl /root/f5PartitionMover.pl /shared/tmp/customerConfiguration.conf"
echo "INFO: This will generate the changes under /root/newCustomerConfig.txt"
echo "INFO: Examine the configuration changes"
echo "INFO: When ready execute f5MoveObjects.pl /root/newCustomerConfig.txt"
echo "---------------------------------------------------------------------------------------------"

