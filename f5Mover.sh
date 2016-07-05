#!/bin/sh
# Created by Luke Yildirim [luke.yildirim@rackspace.com]
# ----------------------------------------------------------------------------------------------
# DISCLAIMER: USE IT AT YOUR OWN RISK
# ----------------------------------------------------------------------------------------------
# This set of scripts make serious changes to your F5 configuration

DATE=`date +%Y-%m-%d`

tmsh save sys ucs beforeMaintenance-$DATE.ucs

# This is where you can do your excludes or simply edit customerConfiguration.conf file and 
# delete the object that you don't want moved.
tmsh list ltm virtual one-line | grep -v FORWARDING > /shared/tmp/customerConfiguration.conf


# get all customer pools
tmsh list ltm pool one-line >> /shared/tmp/customerConfiguration.conf

# get all nodes
tmsh list ltm node one-line >> /shared/tmp/customerConfiguration.conf
