# ARGS:
# 1 - DU machine id
# 2 - RU machine id
# 3 - file name

#!/bin/bash

sshpass -p "scope" scp ./OFH_tgen.py $1:/root/traffic_gen/
sshpass -p "scope" scp ./OFH_tgen.py $2:/root/traffic_gen/
sshpass -p "scope" scp ./$3 $1:/root/traffic_gen/
sshpass -p "scope" scp ./$3 $2:/root/traffic_gen/

IPDU=`sshpass -p "scope" ssh $1 'ifconfig col0 | grep '"'"'inet addr'"'"' | cut -d: -f2 | awk '"'"'{print $1}'"'"''`
echo "DU col0 IP $IPDU"

IPRU=`sshpass -p "scope" ssh $2 'ifconfig col0 | grep '"'"'inet addr'"'"' | cut -d: -f2 | awk '"'"'{print $1}'"'"''`
echo "RU col0 IP $IPRU"

echo "Adjusting MTU size"
sshpass -p "scope" ssh $1 "ifconfig col0 mtu 9000 up"
sshpass -p "scope" ssh $2 "ifconfig col0 mtu 9000 up"


echo "*** Starting IPsec ***"
#Edit /etc/ipsec.secrets
sshpass -p "scope" ssh $1 "sed -i 's/10.207.208.180/${IPDU}/;s/10.207.208.18/${IPRU}/' /etc/ipsec.secrets"
sshpass -p "scope" ssh $2 "sed -i 's/10.207.208.180/${IPRU}/;s/10.207.208.18/${IPDU}/' /etc/ipsec.secrets"

#Edit /etc/ipsec.conf 
sshpass -p "scope" ssh $1 "sed -i 's/10.207.208.180/${IPDU}/;s/10.207.208.18/${IPRU}/' /etc/ipsec.conf"
sshpass -p "scope" ssh $2 "sed -i 's/10.207.208.180/${IPDU}/;s/10.207.208.18/${IPRU}/' /etc/ipsec.conf"

sshpass -p "scope" ssh $1 "sed -i 's/ike=aes256ccm128/#ike=aes256ccm128/;s/esp=aes256ccm128/#esp=aes256ccm128/' /etc/ipsec.conf"
sshpass -p "scope" ssh $1 "sed -i 's/ike=aes256ccm128/#ike=aes256ccm128/;s/esp=aes256ccm128/#esp=aes256ccm128/' /etc/ipsec.conf"

sshpass -p "scope" ssh $1 "sed -i 's/#ike=aes256gcm128/ike=aes256gcm128/;s/#esp=aes256gcm128/esp=aes256gcm128/' /etc/ipsec.conf"
sshpass -p "scope" ssh $2 "sed -i 's/#ike=aes256gcm128/ike=aes256gcm128/;s/#esp=aes256gcm128/esp=aes256gcm128/' /etc/ipsec.conf"

#Allow the kernel to access ipsec by running: 
sshpass -p "scope" ssh $1 "apparmor_parser -R /etc/apparmor.d/usr.lib.ipsec.stroke" 
sshpass -p "scope" ssh $2 "apparmor_parser -R /etc/apparmor.d/usr.lib.ipsec.stroke" 

#Verify ipsec tunnel 
sshpass -p "scope" ssh $1 "ipsec restart" 
sshpass -p "scope" ssh $2 "ipsec restart" 
sleep 5
sshpass -p "scope" ssh $1 "ipsec status" 
sshpass -p "scope" ssh $2 "ipsec status"
sleep 5 


echo "*** Starting the RU ***"
sshpass -p "scope" ssh $2 "cd traffic_gen && python3 OFH_tgen.py -r -i $IPDU -f $3" &
sleep 2

echo "*** Starting the DU ***"
sshpass -p "scope" ssh $1 "cd traffic_gen && python3 OFH_tgen.py -i $IPRU -f $3"
wait

#stop ipsec 
echo "*** Stopping ipsec ***"
sshpass -p "scope" ssh $1 "ipsec stop" 
sshpass -p "scope" ssh $2 "ipsec stop" 
sleep 5
sshpass -p "scope" ssh $1 "ipsec status" 
sshpass -p "scope" ssh $2 "ipsec status" 
sleep 10


echo "*** Starting the RU ***"
sshpass -p "scope" ssh $2 "cd traffic_gen && python3 OFH_tgen.py -r -i $IPDU -f $3" &
sleep 2

echo "*** Starting the DU ***"
sshpass -p "scope" ssh $1 "cd traffic_gen && python3 OFH_tgen.py -i $IPRU -f $3"
wait
