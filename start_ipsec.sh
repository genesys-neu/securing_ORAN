# ARGS:
# 1 - gNB machine id
# 2 - RIC machine id


#!/bin/bash

sshpass -p "scope" scp ./ipsec.conf $1:/etc/ipsec.conf
sshpass -p "scope" scp ./ipsec.secrets $1:/etc/ipsec.secrets
sshpass -p "ChangeMe" scp ./ipsec.conf $2:/etc/ipsec.conf
sshpass -p "ChangeMe" scp ./ipsec.secrets $2:/etc/ipsec.secrets

IPgNB=`sshpass -p "scope" ssh $1 'ifconfig col0 | grep '"'"'inet addr'"'"' | cut -d: -f2 | awk '"'"'{print $1}'"'"''`
echo "gNB col0 IP $IPgNB"

IPRIC=`sshpass -p "ChangeMe" ssh $2 'ifconfig col0 | grep '"'"'inet addr'"'"' | cut -d: -f2 | awk '"'"'{print $1}'"'"''`
echo "RIC col0 IP $IPRIC"

sleep 2
echo "*** Starting IPsec ***"
#Edit /etc/ipsec.secrets
sshpass -p "scope" ssh $1 "sed -i 's/10.207.208.180/${IPgNB}/;s/10.207.208.18/${IPRIC}/' /etc/ipsec.secrets"
sshpass -p "ChangeMe" ssh $2 "sed -i 's/10.207.208.180/${IPRIC}/;s/10.207.208.18/${IPgNB}/' /etc/ipsec.secrets"

sleep 2
#Edit /etc/ipsec.conf 
sshpass -p "scope" ssh $1 "sed -i 's/10.207.208.180/${IPgNB}/;s/10.207.208.18/${IPRIC}/' /etc/ipsec.conf"
sshpass -p "ChangeMe" ssh $2 "sed -i 's/10.207.208.180/${IPgNB}/;s/10.207.208.18/${IPRIC}/' /etc/ipsec.conf"

sshpass -p "scope" ssh $1 "sed -i 's/ike=aes256ccm128/#ike=aes256ccm128/;s/esp=aes256ccm128/#esp=aes256ccm128/' /etc/ipsec.conf"
sshpass -p "ChangeMe" ssh $2 "sed -i 's/ike=aes256ccm128/#ike=aes256ccm128/;s/esp=aes256ccm128/#esp=aes256ccm128/' /etc/ipsec.conf"

sshpass -p "scope" ssh $1 "sed -i 's/#ike=aes256gcm128/ike=aes256gcm128/;s/#esp=aes256gcm128/esp=aes256gcm128/' /etc/ipsec.conf"
sshpass -p "ChangeMe" ssh $2 "sed -i 's/#ike=aes256gcm128/ike=aes256gcm128/;s/#esp=aes256gcm128/esp=aes256gcm128/' /etc/ipsec.conf"

sleep 2
#Allow the kernel to access ipsec by Running: 
sshpass -p "scope" ssh $1 "apparmor_parser -R /etc/apparmor.d/usr.lib.ipsec.stroke" 
sshpass -p "ChangeMe" ssh $2 "apparmor_parser -R /etc/apparmor.d/usr.lib.ipsec.stroke" 

sleep 2
#Verify ipsec tunnel 
sshpass -p "scope" ssh $1 "ipsec restart" 
sshpass -p "ChangeMe" ssh $2 "ipsec restart" 
sleep 5
sshpass -p "scope" ssh $1 "ipsec status" 
sshpass -p "ChangeMe" ssh $2 "ipsec status" 

