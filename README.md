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
* ssh to F5 and drop into shell by typing `run util bash`
* `cd /root`
* `curl -o /root/f5Mover.sh -s https://raw.githubusercontent.com/hyildirim/F5/master/f5Mover.sh`
* `sh f5Mover.sh`
* Read the output carefully.
* `perl /root/f5PartitionMover.pl /shared/tmp/customerConfiguration.conf`  to generate the commands to do to migration
* `perl /root/f5ApplyChanges.pl /root/newCustomerConfig.txt` to apply the changes. If any errors are found, the script will display what they are. Depending on the size of the configuration this may take a while.

```
perl /root/f5ApplyChanges.pl /root/newCustomerConfig.txt
--------------------------------------------------------------------------------
 SUMMARY
--------------------------------------------------------------------------------
Following commands failed
ERROR: Command [tmsh create auth partition Customer] failed.
ERROR: Command [tmsh create ltm virtual /Customer/VS-50.57.21.40-80 { clone-pools { CLONE-POOL { context clientside } CLONE-POOL { context serverside } } destination 50.57.21.40:80 fw-enforced-policy VIP-50.57.21.40 ip-protocol tcp mask 255.255.255.255 pool POOL-one-80 profiles replace-all-with { http { } tcp { } } rules { RULE-server-info } source 0.0.0.0/0 source-address-translation { type automap } }] failed.
ERROR: Command [tmsh create ltm virtual /Customer/VS-one-443 { destination 50.57.21.41:443 ip-protocol tcp mask 255.255.255.255 persist { cookie { default yes } } pool POOL-one6-80 profiles replace-all-with { PROF-http { } clientssl { context clientside } tcp { } } rules { RULE-ipv6 } source 0.0.0.0/0 }] failed.
ERROR: Command [tmsh create ltm virtual /Customer/VS-one-ipv6-443 { destination 2001:4801:1063:302::3239:1529.443 ip-protocol tcp persist { cookie { default yes } } pool POOL-one6-80 profiles replace-all-with { PROF-http { } clientssl { context clientside } tcp { } } rules { RULE-ipv6 } }] failed.
--------------------------------------------------------------------------------
Here is the output for each command
--------------------------------------------------------------------------------
01020037:3: The requested partition (Customer) already exists.
Syntax Error: "clone-pools" unexpected argument "{" one of the following must be specified:
add, delete, modify, none, replace-all-with
Syntax Error: "persist" unexpected argument "{" one of the following must be specified:
none, replace-all-with
Syntax Error: "persist" unexpected argument "{" one of the following must be specified:
none, replace-all-with
--------------------------------------------------------------------------------
```


