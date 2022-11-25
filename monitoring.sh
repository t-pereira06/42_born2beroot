#!/bin/bash

arch=$(uname -m)
cpu=$(cat /proc/cpuinfo | grep "model name" | wc -l)
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)
memused=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')
diskusage=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)", $3,$2,$5}')
cpuload=$(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')
lastboot=$(who -b | awk '{print $3,$4}')
lvmuse=$(lsblk | grep lvm | wc -l | awk '{if ($1) {print "yes";exit;} else {print "no"} }')
conttcp=$(netstat -tunlp | grep tcp | wc -l)
userlog=$(users | wc -w)
netip=$(ip a | grep ether | awk '{print $2}')
sudo=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)

wall "
#Architecture: $arch
#CPU physical: $cpu
#vCPU: $vcpu
#Memory Usage: $memused
#Disk Usage: $diskusage
#CPU load: $cpuload
#Last boot: $lastboot
#LVM use: $lvmuse
#Connexions TCP: $conttcp ESTABLISHED
#User log: $userlog
#Network: IP $netip
#Sudo: $sudo cmd"
