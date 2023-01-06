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
total_disk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{td += $2} END {print td}')
used_disk=$(df -m | grep '^/dev/' | grep -v '/boot$' | awk '{ud += $3} END {print ud}')
percent_disk=$(df -m | grep '^/dev/' | grep -v '/boot$' | awk '{ud += $3} {td+= $2} END {printf("%d"), (ud/td)*100}')

#cpuload
cpuload=$(top -ibn1 | grep "%Cpu" | tr ',' ' ' | awk '{printf 100-$8"%"}')

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
#Disk Usage: $used_disk/{$total_disk}GB ($percent_disk%)
#CPU load: $cpuload
#Last boot: $lastboot
#LVM use: $lvmuse
#Connexions TCP: $conttcp ESTABLISHED
#User log: $userlog
#Network: IP $netip $netmac
#Sudo: $sudo cmd"
