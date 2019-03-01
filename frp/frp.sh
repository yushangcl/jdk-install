#!/usr/bin/env bash
#URL: https://github.com/yushangcl/shell-install/frp
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #               Build Frp                      #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.4.1                 #"
echo "    ################################################"
echo
basePath=$(cd `dirname $0`; pwd)
# 设置展示颜色
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"


#检查server是否启动
check_pid_frps(){
    PID=$(ps -ef | grep frps | grep -v grep | awk '{print $2}')
}

check_pid_frpc(){
    PID=$(ps -ef | grep frpc | grep -v grep | awk '{print $2}')
}

echo && echo -e "请输入一个数字来选择选项
 ${Green_font_prefix}1.${Font_color_suffix} 启动 Frps服務
 ${Green_font_prefix}2.${Font_color_suffix} 停止 Frps服務
 ${Green_font_prefix}3.${Font_color_suffix} 重启 Frps服務
————————————
 ${Green_font_prefix}4.${Font_color_suffix} 启动 Frpc服務
 ${Green_font_prefix}5.${Font_color_suffix} 停止 Frpc服務
 ${Green_font_prefix}6.${Font_color_suffix} 重启 Frpc服務
————————————
 ${Green_font_prefix}7.${Font_color_suffix} 退出！
————————————" && echo

check_pid_frps
if [[ ! -z "${PID}" ]]; then
	echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix}"
else
	echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 但 ${Red_font_prefix}未启动${Font_color_suffix}"
fi


check_pid_frpc
if [[ ! -z "${PID}" ]]; then
	echo -e " Frpc服务 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix}"
else
	echo -e " Frpc服务 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 但 ${Red_font_prefix}未启动${Font_color_suffix}"
fi


#启动 frps
start_frps(){
    check_pid_frps
    [[ ! -z ${PID} ]] && echo -e "${Error} Frps服務 正在运行，请检查 !" && exit 1
    nohup  ${basePath}/frps  -c ${basePath}/frps_full.ini >${basePath}/frps.log 2>&1 &
    echo -e "${Info} Frps服務 启动成功！ \n${Info} 日志文件：${basePath}}/frps.log"
}

#停止 frps
stop_frps(){
    check_pid_frps
    [[ -z ${PID} ]] && echo -e "${Error} Frps 没有运行，请检查 !" && exit 1
    kill ${PID}
    echo -e "${Info} Frps服務 已停止！"
}

#重启 frps
restart_frps(){
    check_pid_frps
    [[ ! -z ${PID} ]] &&  kill ${PID}
    nohup  ${basePath}/frps  -c ${basePath}/frps_full.ini >${basePath}/frps.log 2>&1 &
    echo -e "${Info} Frps服務 重启成功！ \n${Info} 日志文件：${basePath}/frps.out"
}

#启动 frpc
start_frpc(){
    check_pid_frpc
    [[ ! -z ${PID} ]] && echo -e "${Error} Frpc服務 正在运行，请检查 !" && exit 1
    nohup ${basePath}/frpc  -c ${basePath}/frpc.ini >${basePath}/frpc.log 2>&1 &
    echo -e "${Info} Frpc服務 启动成功！ \n${Info} 日志文件：${basePath}}/frpc.log"
}

#停止 frpc
stop_frpc(){
    check_pid_frpc
    [[ -z ${PID} ]] && echo -e "${Error} Frpc 没有运行，请检查 !" && exit 1
    kill ${PID}
    echo -e "${Info} Frpc服務 已停止！"
}

#重启
restart_frpc(){
    check_pid_frpc
    [[ ! -z ${PID} ]] &&  kill ${PID}
    nohup ${basePath}/frpc  -c ${basePath}/frpc.ini >${basePath}/frpc.log 2>&1 &
    echo -e "${Info} Frpc服務 重启成功！ \n${Info} 日志文件：${basePath}/frpc.out"
}
echo
stty erase '^H' && read -p " 请输入数字 [1-7]:" num
case "$num" in
	1)
	start_frps
	;;
	2)
	stop_frps
	;;
	3)
	restart_frps
	;;
    4)
	start_frpc
	;;
	5)
	stop_frpc
	;;
	6)
	restart_frpc
	;;
	7)
	exit 1
	;;
	*)
	echo "请输入正确数字 [1-4]"
	;;
esac