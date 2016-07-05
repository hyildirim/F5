# F5
This repo holds F5 related automation scripts



# Partition Mover
The idea is to be able to move pools, virtuals and nodes from /Common partition to another partition (/Customer by default). This script will generate tmsh commands that will
* delete all virtuals that are found in /Common
* delete all pools that are found in /Common
* delete all nodes that are found in /Common
* create the deleted virtuals, pools and nodes that was deleted earlier in another partition

# ** USE IT AT YOUR OWN RISK **
If you wish to exclude certain objects from deletion, modify the f5mover.sh accordingly prior to running it.
