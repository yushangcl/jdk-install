#!/usr/bin/env bash
#URL: https://github.com/yushangcl/jdk-install
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
check_installed_status(){
   docker=`docker version 2>&1 | head -1`
   if [[ "$docker" == docker* ]]; then
     echo ""
   else
     echo -e "${Error} docker环境 未安装，请先安装 !" && exit 1
   fi
}

install_docker(){

   if ${release} | grep -Eqi "centos"; then
     yum update
     yum install -y yum-utils device-mapper-persistent-data lvm2
     yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
     yum install docker-ce
     systemctl start docker
     systemctl enable docker
   elif ${release} | grep -Eqi "debian|ubuntu"; then
     apt-get update
     apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common
   fi
}