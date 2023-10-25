#!/bin/bash

s=5

ipsec status >> ct_results.txt
echo "*****" >> ct_results.txt

while [ $s -le 1500 ]
do
  ping 172.30.173.174 -s $s -c 10 -i 0.25 -q >> ct_results.txt
  echo "*****" >> ct_results.txt
  ((s+=5))
done

ipsec stop
sleep 10

ipsec status >> pt_results.txt
echo "*****" >> pt_results.txt

s=48

while [ $s -le 1486 ]
do
  ping 172.30.173.174 -s $s -c 10 -i 0.25 -q >> pt_results.txt
  echo "*****" >> pt_results.txt
  ((s+=5))
done

