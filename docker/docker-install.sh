#!/usr/bin/env bash
#URL: https://github.com/yushangcl/docker-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #               Build docker-ce                #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.4.1                 #"
echo "    ################################################"
echo

# 设置展示颜色
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#检查系统
check_sys(){
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
    elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
    elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    fi
    bit=$(uname -m)
    echo "系统环境：$release $bit"
}

#检查安装状态
check_docker_installed_status(){
   docker=`docker version 2>&1 | head -1`
   if [[ "$docker" == docker* ]]; then
     echo -e "${Error} 检测到 Docker环境 已安装!" && check_docker_compose_installed
   else
     echo ""
   fi
}

check_docker_compose_installed(){
    check_docker_compose_installed_status
     if [[ "$docker" == docker-compose* ]]; then
         echo -e "${Error} 检测到 Docker-compose环境 已安装!" && exit 1
       else
         echo ""
       fi
}

install_docker(){
   if ${release} | grep -Eqi "centos"; then
      yum update -y
      yum install -y yum-utils device-mapper-persistent-data lvm2
      yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      yum install -y docker-ce
      sudo mkdir -p /etc/docker
      systemctl enable docker
   elif ${release} | grep -Eqi "debian|ubuntu"; then
     apt-get update -y
     apt-get install -y apt-transport-https ca-certificates curl software-properties-common
     curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
     sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
     apt-get install docker-ce
     systemctl enable docker
   fi
   set_ali_daemon
}

set_ali_daemon(){
    # 设置阿里私有镜像源
      sudo tee /etc/docker/daemon.json <<-'EOF'
        {
          "registry-mirrors": ["https://4xfke570.mirror.aliyuncs.com"]
        }
EOF
      sudo systemctl daemon-reload
      sudo systemctl restart docker
}

install_docker_compose() {
     sudo curl -L "https://get.daocloud.io/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
     sudo chmod +x /usr/local/bin/docker-compose
     echo  -e "${Info} Docker-compose环境 已成功安装"

}

install() {
    check_sys
    check_docker_installed_status
    install_docker
    check_docker_compose_installed
    install_docker_compose
}

#安装
install