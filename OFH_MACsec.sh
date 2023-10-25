# ARGS:
# 1 - file name

#!/bin/bash

DU='orantestbed@10.75.13.112'
RU='orantestbed@10.75.14.162'



MACDU='10.10.12.1'
IPDU='192.168.40.1'

MACRU='10.10.12.2'
IPRU='192.168.40.2'


echo "*** Running without MACsec ***"
echo "*** Starting the RU ***"
sshpass -p "op3nran" ssh $RU "cd traffic_gen && python3 OFH_tgen.py -r -i $IPDU -f $1" &
sleep 2

echo "*** Starting the DU ***"
sshpass -p "op3nran" ssh $DU "cd traffic_gen && python3 OFH_tgen.py -i $IPRU -f $1"
wait

sleep 10

echo "*** Running with MACsec ***"
echo "*** Starting the RU ***"
sshpass -p "op3nran" ssh $RU "cd traffic_gen && python3 OFH_tgen.py -r -i $MACDU -f $1" &
sleep 2

echo "*** Starting the DU ***"
sshpass -p "op3nran" ssh $DU "cd traffic_gen && python3 OFH_tgen.py -i $MACRU -f $1"
wait
