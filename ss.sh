#!/usr/bin/env bash
version=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
echo centos version: $version
case "$version" in
  8)
    dnf install python2
	  alternatives --set python /usr/bin/python2
  ;;
  7)
  yum update
  yum install -y gcc
  ;;
  6)
  ;;
  *)
  echo -e "版本不是6，7，8"
  ;;
esac

echo 'open ports 23333 23335 23337 43337 38593 6934 and reload firewall'
echo && read -e -p "or add more by entering you customize ports split by comma : " portstr
ports="23333,23335,23337,43337,38593,6934,$portstr"
{
   ifs_old=$IFS
   IFS=$','
   for i in $ports
   do
   firewall-cmd --zone=public --add-port=${i}/tcp --permanent
   done
}
echo 'reload firewall'
firewall-cmd --reload

echo && read -e -p "input ssh port(22) you want to change: " sshport

echo change ssh port to $sshport and reload
sed -i "s|#Port 22|Port $sshport|" /etc/ssh/sshd_config

echo 'install semanage'
yum provides semanage
yum install policycoreutils-python

echo 'current ssh port'
semanage port -l | grep ssh

echo add $sshport to ssh port
semanage port -a -t ssh_port_t -p tcp $sshport

echo 'restart ssh service'
service sshd restart

yum -y install wget
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
