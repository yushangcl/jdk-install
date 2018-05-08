#!/usr/bin/env bash
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

license_install_path="usr/local/app/JetLicense/"

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
   java=`java -version 2>&1 | head -1`
   if [[ "$java" == java* ]]; then
     echo ""
   else
     echo -e "${Error} Java环境 未安装，请先安装 !" && exit 1
   fi
}

check_pid(){
    PID=$(ps -ef | grep LicenseServer-1.0-jar-with-dependencies.jar | grep -v grep | awk '{print $2}')
}


Install_license(){
    wget -P ${license_install_path} "https://github.com/yushangcl/LicenseServer/releases/download/1.0.0/LicenseServer-1.0-jar-with-dependencies.jar"
}

Uninstall_license(){
    rm -rf ${license_install_path}
}


Start_license(){
    check_installed_status
    check_pid
    [[ ! -z ${PID} ]] && echo -e "${Error} JetLicense 正在运行，请检查 !" && exit 1
    nohup java -jar ${license_install_path}/LicenseServer-1.0-jar-with-dependencies.jar  -p 8081 >license.out 2>&1 &
    exit 1
}
Stop_license(){
    check_installed_status
    check_pid
    [[ -z ${PID} ]] && echo -e "${Error} JetLicense 没有运行，请检查 !" && exit 1
    kill ${PID}
    exit 1
}
Restart_license(){
    check_installed_status
    check_pid
    [[ ! -z ${PID} ]] &&  kill ${PID}
    nohup java -jar ${license_install_path}/LicenseServer-1.0-jar-with-dependencies.jar  -p 8081 >license.out 2>&1 &
}



echo && echo -e "请输入一个数字来选择选项

 ${Green_font_prefix}1.${Font_color_suffix} 安装 JetLicense
 ${Green_font_prefix}2.${Font_color_suffix} 升级 JetLicense
 ${Green_font_prefix}3.${Font_color_suffix} 卸载 JetLicense
————————————
 ${Green_font_prefix}4.${Font_color_suffix} 启动 JetLicense
 ${Green_font_prefix}5.${Font_color_suffix} 停止 JetLicense
 ${Green_font_prefix}6.${Font_color_suffix} 重启 JetLicense
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
stty erase '^H' && read -p " 请输入数字 [1-6]:" num
case "$num" in
	1)
	Install_license
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
	*)
	echo "请输入正确数字 [1-6]"
	;;
esac



