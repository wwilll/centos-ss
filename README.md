# centos-ss
centos下ss一键脚本
兼容centos8下自动安装python2
默认开放端口6934，23333，23335
修改ssh端口为6934

执行 wget -N --no-check-certificate https://raw.githubusercontent.com/wwilll/centos-ss/master/ss.sh && chmod +x ss.sh && ./ss.sh

# init ssh
修改ssh端口(示例22)，允许root + 密码登录

执行 wget -N --no-check-certificate https://raw.githubusercontent.com/wwilll/centos-ss/master/init_ssh_config.sh && chmod +x init_ssh_config.sh && ./init_ssh_config.sh 22


# init docker compose
修改ssh端口(示例22)，允许root + 密码登录

执行 wget -N --no-check-certificate https://raw.githubusercontent.com/wwilll/centos-ss/master/init_docker.sh && chmod +x init_docker.sh && ./init_docker.sh
