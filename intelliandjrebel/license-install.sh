#!/usr/bin/env bash
#URL: https://github.com/yushangcl/jdk-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #               Build JetLicense               #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.4.1                 #"
echo "    ################################################"
echo

license_install_path="/usr/local/JetLicense"
license_conf="/usr/local/JetLicense/license.conf"

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
check_java_installed_status(){
   java=`java -version 2>&1 | head -1`
   if [[ "$java" == java* ]]; then
     echo ""
   else
     echo -e "${Error} Java环境 未安装，请先安装 !" && exit 1
   fi
}

#检查server是否启动
check_pid(){
    PID=$(ps -ef | grep LicenseServer-1.0-jar-with-dependencies.jar | grep -v grep | awk '{print $2}')
}

#设置端口
Set_port(){
    while true
        do
        echo -e "请输入 LicenseServer 监听端口 [1-65535]"
        stty erase '^H' && read -p "(默认端口: 8081):" ct_port
        [[ -z "${ct_port}" ]] && ct_port="8081"
        expr ${ct_port} + 0 &>/dev/null
        if [[ $? -eq 0 ]]; then
            if [[ ${ct_port} -ge 1 ]] && [[ ${ct_port} -le 65535 ]]; then
                echo && echo "========================"
                echo -e "   端口 : ${Red_background_prefix} ${ct_port} ${Font_color_suffix}"
                echo "========================" && echo
                break
            else
                echo "输入错误, 请输入正确的端口。"
            fi
        else
            echo "输入错误, 请输入正确的端口。"
        fi
    done
}

#写入配置文件
Write_config(){
mkdir ${license_install_path}
cat > ${license_conf}<<-EOF
    port = ${port}
EOF
}

#读取配置文件
Read_config(){
    [[ ! -e ${license_conf} ]] && echo -e "${Error} JetLicense 配置文件不存在 !" && exit 1
    port=`cat ${license_conf}|grep "port = "|awk -F "port = " '{print $NF}'`
}

#安装
Install_license(){
    Set_port
    Write_config
     wget --no-check-certificate  -P ${license_install_path/} "https://raw.githubusercontent.com/yushangcl/shell-install/master/intelliandjrebel/binaries/LicenseServer-1.0-jar-with-dependencies.jar"
}

#卸载
Uninstall_license(){
    rm -rf ${license_install_path}

    echo "确定要卸载 LicenseServer ? (y/N)"
	echo
	stty erase '^H' && read -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
		check_pid
		[[ ! -z $PID ]] && kill -9 ${PID}
		rm -rf ${license_install_path}
		echo && echo "LicenseServer 卸载完成 !" && echo
	else
		echo && echo "卸载已取消..." && echo
	fi
}

#启动
Start_license(){
    check_java_installed_status
    check_pid
    Read_config
    [[ ! -z ${PID} ]] && echo -e "${Error} JetLicense 正在运行，请检查 !" && exit 1
    nohup java -jar ${license_install_path}/LicenseServer-1.0-jar-with-dependencies.jar  -p ${port} >${license_install_path}/license.out 2>&1 &
    echo -e "${Info} JetLicense 启动成功！ \n${Info} 日志文件：${license_install_path}/license.out"
}

#停止
Stop_license(){
    check_java_installed_status
    check_pid
    [[ -z ${PID} ]] && echo -e "${Error} JetLicense 没有运行，请检查 !" && exit 1
    kill ${PID}
    echo -e "${Info} JetLicense 已停止！"
}

#重启
Restart_license(){
    check_java_installed_status
    check_pid
    Read_config
    [[ ! -z ${PID} ]] &&  kill ${PID}
    nohup java -jar ${license_install_path}/LicenseServer-1.0-jar-with-dependencies.jar  -p ${port} >license.out 2>&1 &
    echo -e "${Info} JetLicense 重启成功！ \n${Info} 日志文件：${license_install_path}/license.out"
}

echo && echo -e "请输入一个数字来选择选项

 ${Green_font_prefix}1.${Font_color_suffix} 安装 JetLicense
 ${Green_font_prefix}2.${Font_color_suffix} 升级 JetLicense
 ${Green_font_prefix}3.${Font_color_suffix} 卸载 JetLicense
————————————
 ${Green_font_prefix}4.${Font_color_suffix} 启动 JetLicense
 ${Green_font_prefix}5.${Font_color_suffix} 停止 JetLicense
 ${Green_font_prefix}6.${Font_color_suffix} 重启 JetLicense
————————————
 ${Green_font_prefix}7.${Font_color_suffix} 退出 安装！
————————————" && echo
if [[ -e ${license_install_path} ]]; then
	check_pid
	if [[ ! -z "${PID}" ]]; then
		echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix}"
	else
		echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 但 ${Red_font_prefix}未启动${Font_color_suffix}"
	fi
else
	echo -e " 当前状态: ${Red_font_prefix}未安装${Font_color_suffix}"
fi
echo
stty erase '^H' && read -p " 请输入数字 [1-7]:" num
case "$num" in
	1)
	Install_license
	Restart_license
	;;
	2)
	echo "该功能未实现" exit 1
	;;
	3)
	Uninstall_license
	;;
	4)
	Start_license
	;;
	5)
	Stop_license
	;;
	6)
	Restart_license
	;;
	7)
	exit 1
	;;
	*)
	echo "请输入正确数字 [1-7]"
	;;
esac



