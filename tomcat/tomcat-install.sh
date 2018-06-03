#!/usr/bin/env bash
#URL: https://github.com/yushangcl/shell-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #                Build Tomcat                  #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.4.1                 #"
echo "    ################################################"

#变量
choice_mun=0
port=8080
tomcat="apache-tomcat-7.0.86.tar.gz"
tomcat_install_path="/usr/local/tomcat"
tomcat_temp="/var/tmp/tomcat"
tomcat_install_path_=${tomcat_install_path}

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
    echo " 系统环境：$release $bit"
}

#检查是否安装java环境
check_java_status(){
   java=`java -version 2>&1 | head -1`
   if [[ "$java" == java* ]]; then
     echo " 检测到已安装的Java版本：$java"
     echo " 安装路径为:" `which java`
   else
     echo " 未检测到Java环境，请安装Java环境后再执行该脚本" exit 1
   fi
}

check_installed_status(){
    [[ ! -e ${tomcat_install_path} ]] && echo -e "${Error} Cloud Torrent 没有安装，请检查 !" && exit 1
}

check_pid(){
    PID=$(ps -ef | grep tomcat | grep -v grep | awk '{print $2}')
}

#用户设置安装版本
set_version(){
    echo && echo -e "请输入一个数字来选择选项"
    echo -e " ${Green_font_prefix}1.${Font_color_suffix} 安装 Tomcat 7"
    echo -e " ${Green_font_prefix}2.${Font_color_suffix} 安装 Tomcat 8"
    echo -e " ${Green_font_prefix}3.${Font_color_suffix} 安装 Tomcat 9"
    echo
    stty erase '^H' && read -p " 请输入数字 [1-3]:" choice_mun
    echo
}

# 下载安装包
download(){
    case "$choice_mun" in
        1)
            tomcat=apache-tomcat-7.0.86.tar.gz
            wget --no-check-certificate -P ${tomcat_temp} "http://mirrors.shu.edu.cn/apache/tomcat/tomcat-7/v7.0.86/bin/$tomcat"
        ;;
        2)
            tomcat=apache-tomcat-8.5.31.tar.gz
            wget --no-check-certificate -P ${tomcat_temp} "http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.31/bin/$tomcat"
        ;;
        3)
            tomcat=apache-tomcat-9.0.8.tar.gz
            wget --no-check-certificate -P ${tomcat_temp} "http://mirror.bit.edu.cn/apache/tomcat/tomcat-9/v9.0.8/bin/$tomcat"
        ;;
        *)
        echo "${Error}请输入正确数字 [1-3]" && exit 1
        ;;
    esac
}

#解压安装
tar_install(){
    [[ ! -e "$tomcat_temp/$tomcat" ]] && echo -e "${Error} Tomcat 下载失败 !" && exit 1
    [[ ! -e "$tomcat_install_path" ]] && mkdir "$tomcat_install_path"
    tar xzf "$tomcat_temp/$tomcat" -C "$tomcat_install_path/"
    [[ ! -e "$tomcat_install_path/" ]] && echo -e "${Error} Tomcat 解压失败(可能是 压缩包损坏 或者 没有安装 Gzip) !" && exit 1
    rm -rf "$tomcat_temp/$tomcat"
}

Add_iptables(){
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${port} -j ACCEPT
    iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${port} -j ACCEPT

}

Save_iptables(){
    if [[ ${release} == "centos" ]]; then
        service iptables save
    else
        iptables-save > /etc/iptables.up.rules
    fi
}

Set_iptables(){
    if [[ ${release} == "centos" ]]; then
        service iptables save
        chkconfig --level 2345 iptables on
    else
        iptables-save > /etc/iptables.up.rules
        echo -e '#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules' > /etc/network/if-pre-up.d/iptables
        chmod +x /etc/network/if-pre-up.d/iptables
    fi
}


#主方法
Install_tomcat(){
    echo && echo -e "${Info} 开始检查 系统环境..."
#    check_sys
    echo && echo -e "${Info} 开始检查 安装状态..."
#    check_java_status
    echo && echo -e "${Info} 开始设置 安装版本..."
#    set_version
    echo && echo -e "${Info} 开始下载 Tomcat安装包..."
#    download
    echo && echo -e "${Info} 解压安装中..."
#    tar_install
    echo && echo -e "${Info} 开始设置 iptables防火墙..."
#    Set_iptables
    echo && echo -e "${Info} 开始添加 iptables防火墙规则..."
#    Add_iptables
    echo && echo -e "${Info} 开始保存 iptables防火墙规则..."
#    Save_iptables
    echo && echo -e "${Info} 开始添加 环境变量..."
#    add_path
    echo && echo -e "${Info} 开始创建 配置文件..."
#    create_init
    echo && echo -e "${Info} 所有步骤 安装完毕，开始启动..."
}

get_tomcat_install_path(){
   cd $tomcat_install_path/apache-tomcat*
   tomcat_install_path_=$(cd `dirname $0`; pwd)
}

Start_tomcat(){
    check_installed_status
    check_pid
    get_tomcat_install_path
    [[ ! -z ${PID} ]] && echo -e "${Error} Tomcat 正在运行，请检查 !" && exit 1
    ${tomcat_install_path_}/bin/startup.sh
    exit 1
}
Stop_tomcat(){
    check_installed_status
    check_pid
    get_tomcat_install_path
    [[ -z ${PID} ]] && echo -e "${Error} Tomcat 没有运行，请检查 !" && exit 1
     ${tomcat_install_path_}/bin/shutdown.sh
    exit 1
}
Restart_tomcat(){
    check_installed_status
    check_pid
    get_tomcat_install_path
    [[ ! -z ${PID} ]] && /usr/local/tomcat/apache-tomcat-7.0.86/bin/shutdown.sh
     ${tomcat_install_path_}/bin/startup.sh
}

Uninstall_ct(){
    check_installed_status
    echo "确定要卸载 Cloud Torrent ? (y/N)"
    echo
    stty erase '^H' && read -p "(默认: n):" unyn
    [[ -z ${unyn} ]] && unyn="n"
    if [[ ${unyn} == [Yy] ]]; then
        check_pid
        [[ ! -z $PID ]] && kill -9 ${PID}
        Read_config
        Del_iptables
        rm -rf ${file} && rm -rf /etc/init.d/cloudt
        if [[ ${release} = "centos" ]]; then
            chkconfig --del cloudt
        else
            update-rc.d -f cloudt remove
        fi
        echo && echo "Cloud torrent 卸载完成 !" && echo
    else
        echo && echo "卸载已取消..." && echo
    fi
}
echo && echo -e "请输入一个数字来选择选项

 ${Green_font_prefix}1.${Font_color_suffix} 安装 Tomcat
 ${Green_font_prefix}2.${Font_color_suffix} 升级 Tomcat
 ${Green_font_prefix}3.${Font_color_suffix} 卸载 Tomcat
————————————
 ${Green_font_prefix}4.${Font_color_suffix} 启动 Tomcat
 ${Green_font_prefix}5.${Font_color_suffix} 停止 Tomcat
 ${Green_font_prefix}6.${Font_color_suffix} 重启 Tomcat
————————————" && echo
if [[ -e ${tomcat_install_path} ]]; then
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
stty erase '^H' && read -p " 请输入数字 [1-9]:" num
case "$num" in
	1)
	Install_tomcat
	;;
	2)
	echo "该功能未实现" exit 1
	;;
	3)
	Uninstall_ct
	;;
	4)
	Start_tomcat
	;;
	5)
	Stop_tomcat
	;;
	6)
	Restart_tomcat
	;;
	*)
	echo "请输入正确数字 [1-6]"
	;;
esac
