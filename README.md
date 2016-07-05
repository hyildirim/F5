# F5
This repo holds F5 related automation scripts



# Partition Mover
The idea is to be able to move pools, virtuals and nodes from /Common partition to another partition (/Customer by default). This script will generate tmsh commands that will
* Delete all virtuals that are found in /Common
* Delete all pools that are found in /Common
* Delete all nodes that are found in /Common
* Re-create the deleted virtuals, pools and nodes that was deleted earlier in another partition

## ***** USE IT AT YOUR OWN RISK *****
If you wish to exclude certain objects from deletion, you can either
* modify the f5Mover.sh accordingly prior to running it.
* modify the configuration file generated /shared/tmp/customerConfiguration.conf


## How to use it
* ssh to F5 and drop into shell by typing "run util bash"
* cd /root
* curl -o /root/f5Mover.sh -s https://raw.githubusercontent.com/hyildirim/F5/master/f5Mover.sh
* sh f5Mover.sh
* Read the output carefully.
* **perl /root/f5PartitionMover.pl /shared/tmp/customerConfiguration.conf**  to generate the commands to do to migration
* **perl /root/f5ApplyChanges.pl /root/newCustomerConfig.txt** to apply the changes. If any errors are found, the script will display what they are.
