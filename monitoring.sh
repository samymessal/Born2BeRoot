!/bin/bash
#wall $'#Architecture: ' `hostnamectl | grep "Operating System" | cut -d ' ' -f5- ` `awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[\t]*//'` `arch` \
#$'\n#CPU physical: '`cat /proc/cpuinfo | grep processor | wc -l` \
#$'\n#vCPU: '`cat /proc/cpuinfo | grep processor | wc -l` \
#$'\n'`free -m | awk 'NR==2{printf "#Memory usage: %s/%sMB (%.2f%%)", $3, $2, $3*100/$2 }'` \
#$'\n'`df -h| awk '$NF=="/"{printf "#Disk usage: %d/%dGB (%s)", $3, $2, $5}'` \
#$'\n'`top -bn1 | grep load | awk '{printf "#CPU load: %.2f\n", $(NF-2)}'` \
#$'\n#Last boot: ' `who -b | awk '{print $3" "$4" "$5}'` \
#$'\n#LVM use: ' `lsblk |grep lvm | awk '{if ($1) {printf "yes";exit;}else {printf "no"}}'`\
#$'\n#Connection TCP: ' `netstat -an | grep ESTABLISHED | wc -l `\
#$'\n#User log: ' `who | cut -d " " -f 1 | sort -u | wc -l` \
#$'\nNetwiek: IP ' `hostname -I`"("`ip a | grep link/ether | awk '{print $2}'`")" \
#$'\n#Sudo: ' `grep 'sudo ' /var/log/auth.log | wc -l`


architecture=$(uname -a);
physical=$(cat /proc/cpuinfo | grep ^physical | wc -l);
virtual=$(cat /proc/cpuinfo | grep processor | wc -l);
mem_used=$(free --mega| awk '{if(NR==2)print $3}');
mem_avai=$(free --mega| awk '{if(NR==2)print $2}');
result_mem=$(free --mega | awk '{if (NR==2) printf("%.2f",$3/$2 * 100)}');
disk_usage=$(df -h --total | awk 'END{printf("%d/%dGb (%d%%)", $3, $2, $3/$2 * 100)}');
cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | awk '{printf("%.1f%%"), $1 + $3}');
date=$(uptime -s);
lvm=$(if [[ lsblk | grep lvm | wc -l -eq 0]] then echo 'No' else echo 'Yes' fi);
wall	"#Architecture: $architecture
#CPU physical : $physical
#vCPU : $disk_usage;
#Memory Usage: $mem_used/$mem_avai MB $result_mem %
#Disk Usage: $disk_usage
#CPU load: $cpu_load
#Last boot: $date
#LVM: $lvm"
