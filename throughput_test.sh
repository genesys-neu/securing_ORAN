#!/bin/bash

s=40

ipsec status >> ct_iperf_o.txt
echo "*****" >> ct_iperf_o.txt

while [ $s -le 2000 ]
do
  ss="${s}M"
  iperf3 -c 172.30.203.203 -t 10 -b $ss -V >> ct_iperf_o.txt
  echo "*****" >> ct_iperf_o.txt
  echo "$s complete"
  ((s+=40))
done

ipsec stop
sleep 10

ipsec status >> pt_iperf_o.txt
echo "*****" >> pt_iperf_o.txt

s=40

while [ $s -le 2000 ]
do
  ss="${s}M"
  iperf3 -c 172.30.203.203 -t 10 -b $ss -V >> pt_iperf_o.txt
  echo "*****" >> pt_iperf_o.txt
  echo "$s complete"
  ((s+=40))
done

