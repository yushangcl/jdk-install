#!/usr/bin/env bash
#URL: https://github.com/shell-install/jdk/jre-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #                  Build JRE                   #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.4.1                 #"
echo "    ################################################"
echo

#jdk安装路径
jdk_file_path="/usr/local/jre"

#jdk下载临时目录
jdk_temp="/var/tmp/jre"
choice_mun=0

#默认jdk版本
jdk="jre-8u171-linux.tar.gz"

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
     echo "检测到已安装的Java版本：$java"
     echo ""
     echo "安装路径为:" `which java`
     echo ""
     echo "如果需要安装新的版本，请卸载当前版本后重新运行该脚本"
     echo ""
     exit
   fi
}

#用户设置安装版本
set_version(){
    echo && echo -e "请输入一个数字来选择选项"
    echo -e " ${Green_font_prefix}1.${Font_color_suffix} 安装 JDK 7"
    echo -e " ${Green_font_prefix}2.${Font_color_suffix} 安装 JDK 8"
    echo -e " ${Green_font_prefix}3.${Font_color_suffix} 安装 JDK 10"
    echo
    stty erase '^H' && read -p " 请输入数字 [1-3]:" choice_mun
    echo

}


download_jdk8(){
      wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -P ${jdk_temp} "http://javadl.oracle.com/webapps/download/AutoDL?BundleId=233162_512cd62ec5174c3487ac17c61aaa89e8"
}

# 下载安装包
download(){
    case "$choice_mun" in
        1)
        #download_jdk7
        ;;
        2)
        download_jdk8
        ;;
        3)
        #download_jdk10
        ;;
        *)
        echo "${Error}请输入正确数字 [1-3]" && exit 1
        ;;
    esac
}

#解压安装
tar_install(){
    [[ ! -e "$jdk_temp/$jdk" ]] && echo -e "${Error} JDK 下载失败 !" && exit 1
    [[ ! -e "$jdk_file_path" ]] && mkdir "$jdk_file_path"
    tar xzf "$jdk_temp/$jdk" -C "$jdk_file_path/"
    [[ ! -e "$jdk_file_path/" ]] && echo -e "${Error} JDK 解压失败(可能是 压缩包损坏 或者 没有安装 Gzip) !" && exit 1
    rm -rf "$jdk_temp/$jdk"
}

#设置环境变量
add_path(){
    cd $jdk_file_path/jdk*
    home=$(cd `dirname $0`; pwd)
    echo "#JAVA_HOME" >> /etc/profile
    echo "JAVA_HOME=${home}" >> /etc/profile
    echo "CLASSPATH=\$JAVA_HOME/lib" >> /etc/profile
    echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile
}

#主方法
Install_jdk(){
    echo && echo -e "${Info} 开始检查 系统环境..."
    check_sys
    echo && echo -e "${Info} 开始检查 安装状态..."
    check_installed_status
    echo && echo -e "${Info} 开始设置 安装版本..."
    set_version
    echo && echo -e "${Info} 开始下载 JDK安装包..."
    download
    echo && echo -e "${Info} 解压安装中..."
    tar_install
    echo && echo -e "${Info} 开始添加 环境变量..."
    add_path
}

#安装
Install_jdk

echo
echo "*******安装结束********"
echo "安装路径为:" `which java`
echo ""
echo "${Tip}请手动执行命令：source /etc/profile "