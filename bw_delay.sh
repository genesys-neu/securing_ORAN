#!/bin/bash

s=40
ip='172.30.101.104'

ipsec status >> ct_throughput.txt
echo "*****" >> ct_throughput.txt

ipsec status >> ct_delay.txt
echo "*****" >> ct_delay.txt

while [ $s -le 10000 ]
do
  ss="${s}M"
  iperf3 -c $ip -t 35 -b $ss -V >> ct_throughput.txt &
  sleep 1
  ping $ip -s 1425 -c 100 -i 0.25 -q >> ct_delay.txt
  wait
  echo "*****" >> ct_throughput.txt
  echo "*****" >> ct_delay.txt
  echo "$s complete"
  sleep 2
  ((s+=200))
done

ipsec stop
sleep 10

ipsec status >> pt_throughput.txt
echo "*****" >> pt_throughput.txt

ipsec status >> pt_delay.txt
echo "*****" >> pt_delay.txt

s=40

while [ $s -le 10000 ]
do
  ss="${s}M"
  iperf3 -c $ip -t 35 -b $ss -V >> pt_throughput.txt &
  sleep 1
  ping $ip -s 1425 -c 100 -i 0.25 -q >> pt_delay.txt
  wait
  echo "*****" >> pt_throughput.txt
  echo "*****" >> pt_delay.txt
  echo "$s complete"
  sleep 2
  ((s+=200))
done

