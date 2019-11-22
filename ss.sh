#!/usr/bin/env bash
version=`cat /etc/redhat-release|sed -r 's/.* ([0-9]+)\..*/\1/'`
case "$version" in
  8)
  echo 8
    dnf install python2
	  alternatives --set python /usr/bin/python2
  ;;
  7)
  echo 7
  yum update
  yum install -y gcc
  ;;
  6)
  echo 6
  ;;
  *)
  echo -e "版本不是6，7，8"
  ;;
esac

firewall-cmd --zone=public --add-port=23333/tcp --permanent
firewall-cmd --zone=public --add-port=23335/tcp --permanent
firewall-cmd --zone=public --add-port=6934/tcp --permanent
firewall-cmd --reload
sed -i 's|#Port 22|Port 6943|' /etc/ssh/sshd_config
service sshd restart
yum -y install wget
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
