#!/bin/bash

# architeture
arch=$(uname -a)

#cpu
cpu=$(cat /proc/cpuinfo | grep "model name" | wc -l)

#vcpu
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)

#memused
memused=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')

#diskusage
diskusage=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)", $3,$2,$5}')

#cpuload
cpuload=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 100 - $cpuload)
cpu_fin=$(printf "%.1f" $cpu_op)

#lastboot
lastboot=$(who -b | awk '{print $3,$4}')

#lvmuse
lvmuse=$(lsblk | grep lvm | wc -l | awk '{if ($1) {print "yes";exit;} else {print "no"} }')

#conttcp
conttcp=$(ss -ta | grep ESTAB | wc -l)

#userlog
userlog=$(users | wc -w)

#netip and mac
netip=$(hostname -I)
netmac=$(ip link | grep "link/ether" | awk '{print $2}')

#sudo
sudo=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)

wall "
#Architecture: $arch
#CPU physical: $cpu
#vCPU: $vcpu
#Memory Usage: $memused
#Disk Usage: $diskusage
#CPU load: $cpu_fin%
#Last boot: $lastboot
#LVM use: $lvmuse
#Connexions TCP: $conttcp ESTABLISHED
#User log: $userlog
#Network: IP $netip $netmac
#Sudo: $sudo cmd"
