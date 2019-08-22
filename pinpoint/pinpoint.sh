#!/usr/bin/env bash
#URL: https://github.com/yushangcl/shell-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #               Build pinpoint                 #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.0.1                 #"
echo "    ################################################"
echo
# 设置展示颜色
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

# pinpoint安装路径
install_path="/usr/local/pinpoint"
ip=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/'`

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

}
check_sys_install() {
    check_sys
    if [[ "${release} | grep -Eqi 'centos'" ]]; then
        echo  -e "${Info} 系统环境：$release $bit"
        echo ""
    else
        echo -e "${Error} 系统环境：$release $bit 该脚本不支持该系统"  && exit 1
    fi
}

#检查安装状态
check_docker_installed_status(){
   docker=`docker version 2>&1 | head -1`

}
check_docker_compose_installed_status(){
   docker=`docker-compose version 2>&1 | head -1`
}


check_docker_installed(){
    check_docker_installed_status
   if [[ "$docker" == *Docker* ]]; then
      echo  -e "${Info} 检测到 Docker环境 已安装"
      echo ""
   else
      echo -e "${Error} Docker环境 未安装，请先安装 !"
      echo ""
   fi
}

check_docker_not_installed(){
    check_docker_installed_status
    if [[ "$docker" == *Docker* ]]; then
        echo ""
    else
        echo -e "${Error} Docker环境 未安装，请先安装 !" && exit 1
        echo ""
    fi
}
check_docker_compose_installed(){
    check_docker_compose_installed_status
     if [[ "$docker" == docker-compose* ]]; then
         echo  -e "${Info} 检测到 Docker-compose环境 已安装"
         echo ""
         # 检查docker 是否启动
         if [[ "-f docker stats | grep -Eqi 'Cannot'" ]]; then
            echo -e "${Error} 检测到 Docker状态: ${Red_font_prefix}未启动！${Font_color_suffix} "
         else
            # 检查容器启动状态
            check_pid_all
         fi
       else
         echo -e "${Error} Docker-compose环境 未安装，请先安装 !"
         echo ""
       fi
}
check_docker_compose_not_installed(){
    check_docker_compose_installed_status
     if [[ "$docker" == docker-compose* ]]; then
         echo ""
       else
         echo -e "${Error} Docker-compose环境 未安装，请先安装 !" && exit 1
         echo ""
       fi
}

# 安装docker
install_docker() {
   # 检查docker是否安装
   check_docker_installed_status
   if [[ "$docker" == *Docker* ]]; then
     echo  -e "${Error} 检测到 Docker环境 已安装"
     echo ""
   else
    yum update -y
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
    sudo mkdir -p /etc/docker
    # 设置阿里私有镜像源
    sudo tee /etc/docker/daemon.json <<-'EOF'
        {
          "registry-mirrors": ["https://4xfke570.mirror.aliyuncs.com"]
        }
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker

    echo  -e "${Info} Docker环境 已成功安装"
   fi

}
# 安装docker_compose
install_docker_compose(){
   check_docker_compose_installed_status
   if [[ "$docker" == docker-compose* ]]; then
     echo  -e "${Error} 检测到 Docker-compose环境 已安装"
     echo ""
   else
     sudo curl -L "https://get.daocloud.io/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
     sudo chmod +x /usr/local/bin/docker-compose
     echo  -e "${Info} Docker-compose环境 已成功安装"
   fi

}

# 检查pinpoint是否启动
check_pid_pinpoint_collector(){
    exist=`docker inspect --format '{{.State.Running}}' pinpoint-collector`
    install=`docker ps -a --format "{{.Image}}" --filter name=pinpoint-collector`
    PID=$(docker ps | grep  pinpoint-collector | grep -v grep | awk '{print $2}')
    name='pinpoint-collector'
}
check_pid_pinpoint_web(){
    exist=`docker inspect --format '{{.State.Running}}' pinpoint-web`
    install=`docker ps -a --format "{{.Image}}" --filter name=pinpoint-web`
    PID=$(docker ps | grep  pinpoint-web | grep -v grep | awk '{print $2}')
    name='pinpoint-web      '
}
check_pid_pinpoint_mysql(){
    exist=`docker inspect --format '{{.State.Running}}' pinpoint-mysql`
    install=`docker ps -a --format "{{.Image}}" --filter name=pinpoint-mysql`
    PID=$(docker ps | grep  pinpoint-mysql | grep -v grep | awk '{print $2}')
    name='pinpoint-mysql    '
}
check_pid_pinpoint_hbase(){
    exist=`docker inspect --format '{{.State.Running}}' pinpoint-hbase`
    install=`docker ps -a --format "{{.Image}}" --filter name=pinpoint-hbase`
    PID=$(docker ps | grep  pinpoint-hbase | grep -v grep | awk '{print $2}')
    name='pinpoint-hbase    '
}
check_pid_pinpoint_docker_zoo2_1(){
    exist=`docker inspect --format '{{.State.Running}}'  pinpoint-docker_zoo1_1`
    install=`docker ps -a --format "{{.Image}}" --filter name=pinpoint-docker_zoo1_1`
    PID=$(docker ps | grep  pinpoint-docker_zoo1_1 | grep -v grep | awk '{print $2}')
    name='docker_zoo1_1     '
}
check_pid_pinpoint_docker_zoo2_2(){
    exist=`docker inspect --format '{{.State.Running}}'  pinpoint-docker_zoo2_1`
    install=`docker ps -a --format "{{.Image}}" --filter name=pinpoint-docker_zoo2_1`
    PID=$(docker ps | grep  pinpoint-docker_zoo2_1 | grep -v grep | awk '{print $2}')
    name='docker_zoo2_1     '
}
check_pid_pinpoint_docker_zoo2_3(){
    exist=`docker inspect --format '{{.State.Running}}'  pinpoint-docker_zoo3_1`
    install=`docker ps -a --format "{{.Image}}" --filter name=pinpoint-docker_zoo3_1`
    PID=$(docker ps | grep  pinpoint-docker_zoo3_1 | grep -v grep | awk '{print $2}')
    name='docker_zoo3_1     '

}
check_run_echo(){
    if [[ "${install}" == "" ]]; then
        echo -e "${Info} ${name##*/} 容器状态: ${Red_font_prefix}未创建${Font_color_suffix} "
    else
        if [[ "${exist}" == "true" ]]; then
            echo -e "${Info} ${name##*/} 容器状态: ${Green_font_prefix}已创建${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix}"
        else
            echo -e "${Info} ${name##*/} 容器状态: ${Green_font_prefix}已创建${Font_color_suffix} 但 ${Red_font_prefix}未启动${Font_color_suffix}"
        fi
    fi
}
# 检查所有容器状态
check_pid_all(){
    check_pid_pinpoint_collector
    check_run_echo
    check_pid_pinpoint_web
    check_run_echo
    check_pid_pinpoint_mysql
    check_run_echo
    check_pid_pinpoint_hbase
    check_run_echo
    check_pid_pinpoint_docker_zoo2_1
    check_run_echo
    check_pid_pinpoint_docker_zoo2_2
    check_run_echo
    check_pid_pinpoint_docker_zoo2_3
    check_run_echo
}

check_docker() {
    check_docker_not_installed
    check_docker_compose_not_installed
    start_docker
}

check_install() {
    check_docker
    check_pid_pinpoint_collector
    [[ "${install}" == "" ]] && echo -e "${Error} pinpoint服務 未安装，请检查 !" && exit 1
}

check_is_install() {
    check_docker
    check_pid_pinpoint_collector
    [[ "${install}" != "" ]] && echo -e "${Error} pinpoint服務 已安装，请检查 !" && exit 1
    [[ "${exist}" == "true" ]] && echo -e "${Error} pinpoint服務 正在运行，请检查 !" && exit 1
}

check_start() {
    check_docker
    check_pid_pinpoint_collector
    [[ "${install}" == "" ]] && echo -e "${Error} pinpoint服務 未安装，请检查 !" && exit 1
    [[ "${exist}" == "true" ]] && echo -e "${Error} pinpoint服務 正在运行，请检查 !" && exit 1
}
check_stop() {
    check_docker
    check_pid_pinpoint_collector
    [[ "${install}" == "" ]] && echo -e "${Error} pinpoint服務 未安装，请检查 !" && exit 1
    [[ "${exist}" == "false" ]] && echo -e "${Error} pinpoint服務 已停止，请检查 !" && exit 1
}

start_docker() {
    echo -e "${Info} 正在启动 Docker  \n"
    sudo systemctl restart docker
    echo -e "${Info} Docker 启动成功！ \n"
}

# 下载clone
clone_pinpoint() {
    yum install git -y
    [[ ! -e "$install_path" ]] && mkdir "$install_path"
    cd ${install_path}
    git clone https://github.com/naver/pinpoint-docker.git
}

# 构建 并启动
up_pinpoint() {
    cd ${install_path}/pinpoint-docker
    docker-compose pull && docker-compose up -d
    echo -e "${Info} pinpoint容器 启动成功！ \n"
}

# 停止所有的容器
stop_pinpoint() {
    check_stop
    docker stop $(docker ps -a -q)
    echo -e "${Info} pinpoint容器 停止成功！ \n"
}

# 启动所有的容器
start_pinpoint() {
   check_start
   docker start $(docker ps -a -q)
   echo -e "${Info} pinpoint容器 启动成功！ \n"
}

# 删除所有容器
rm_pinpoint() {
    check_install
    stop_pinpoint
    docker rm $(docker ps -a -q)
    echo -e "${Info} pinpoint容器 删除成功！ \n"
}

# 删除所有镜像
rmi_image_pinpoint() {
    rm_pinpoint
    docker rmi `docker images -q`
    echo -e "${Info} pinpoint镜像 删除成功！ \n"
}

# 停止不需要的容器
useless() {
    echo -e "${Info} 停止不需要的容器"
    docker stop pinpoint-quickstart
    echo -e "${Info} pinpoint-quickstart 已停止"
    docker stop pinpoint-agent
    echo -e "${Info} pinpoint-agent 已停止"
    docker stop pinpoint-flink-taskmanager
    echo -e "${Info} pinpoint-flink-taskmanager 已停止"
    docker stop pinpoint-flink-jobmanager
    echo -e "${Info} pinpoint-flink-jobmanager 已停止。"
    echo
}

echo_success_Info(){
    echo
    echo -e "${Info} ---------------PINPOINT服务访问的地址----------------"
    echo -e "${Info} PINPOINT平台地址：http://127.0.0.1:8079/#/main"
    echo
    echo -e "${Info} ---------------pinpoint-agent下载地址----------------"
    echo -e "${Info} https://upload-1251506627.cos.ap-shanghai.myqcloud.com/pinpoint-agent-1.8.4.tar.gz"
    echo
}

# 安装 启动 pinpoint
install_start_pinpoint(){
    # 检查是已经启动
    check_is_install
    # 构建并启动
    clone_pinpoint
    up_pinpoint
    useless
    check_pid_pinpoint_collector
    echo_success_Info
}


#重启
restart_pinpoint() {
    stop_pinpoint
    start_pinpoint
    useless
    echo_success_Info
}

# 删除容器 并重启
rm_restart_pinpoint() {
    stop_pinpoint
    rm_pinpoint
    up_pinpoint
}



check_all_install(){
    # 校验系统版本
    check_sys_install
    # 检查docker安装状态
    check_docker_installed
    check_docker_compose_installed

    # 如果服务已启动就输出地址
    check_pid_pinpoint_collector
    [[ "${exist}" == "true" ]] && echo_success_Info
}

check_all_install

echo && echo -e "请输入一个数字来选择选项
 ${Green_font_prefix}1.${Font_color_suffix} 安装启动    pinpoint服務 (默认安装Docker环境)
 ${Green_font_prefix}2.${Font_color_suffix} 启    动    pinpoint服務
 ${Green_font_prefix}3.${Font_color_suffix} 停    止    pinpoint服務
 ${Green_font_prefix}4.${Font_color_suffix} 重    启    pinpoint服務
 ${Green_font_prefix}5.${Font_color_suffix} 删除重启    pinpoint服務 (删除容器并重新构建启动)
 ${Green_font_prefix}6.${Font_color_suffix} 删除容器    pinpoint服務
 ${Green_font_prefix}7.${Font_color_suffix} 删除镜像    pinpoint服務
————————————
 ${Green_font_prefix}8.${Font_color_suffix} 安装Docker  pinpoint服務
 ${Green_font_prefix}9.${Font_color_suffix} 安装Compose pinpoint服務
————————————
 ${Green_font_prefix}0.${Font_color_suffix} 退出！
————————————"
echo -e "${Tip} 文档地址：﻿http://t.cn/AiQX0ptN" && echo

stty erase '^H' && read -p " 请输入数字 [0-9]:" num
case "$num" in
	1)
	install_docker
	install_docker_compose
	install_start_pinpoint
	;;
	2)
	start_pinpoint
	useless
	echo_success_Info
	;;
	3)
	stop_pinpoint
	;;
	4)
	restart_pinpoint
	;;
    5)
	rm_restart_pinpoint
	;;
	6)
	rm_pinpoint
	;;
	7)
	rmi_image_pinpoint
	;;
	8)
	install_docker
	;;
	9)
	install_docker_compose
	;;
	0)
	exit 1
	;;
	*)
	echo "请输入正确数字 [0-9]"
	;;
esac

