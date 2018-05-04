#!/usr/bin/env bash
#URL: https://github.com/yushangcl/jdk-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #                  Build JDK                   #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.4.1                 #"
echo "    ################################################"

#检测是否已经安装java环境
echo ""
JAVA_VERSION=`java -version 2>&1 | head -1`
if [[ "$JAVA_VERSION" == java* ]]; then
    echo "检测到已安装的Java版本：$JAVA_VERSION"
    echo ""
    which=`which java`
    echo "安装路径为 $which "
    echo ""
    echo "如果需要安装新的版本，请卸载当前版本后重新运行该脚本"
    echo ""
    exit
fi
#Prepare the installation environment
echo -e ""
echo -e "Prepare the installation environment."
if cat /etc/*-release | grep -Eqi "centos|red hat|redhat"; then
  echo "RPM-based"
  yum -y install wget
elif cat /etc/*-release | grep -Eqi "debian|ubuntu|deepin"; then
  echo "Debian-based"
  apt-get -y install wget
else
  echo "This release is not supported."
  exit
fi
#Check instruction
if getconf LONG_BIT | grep -Eqi "64"; then
  arch=64
else
  arch=32
fi

#download JDK 8
echo "*******开始下载jdk-10.0.1-linux*******"
rm -rf /var/tmp/jdk/*
if cat /etc/*-release | grep -Eqi "raspbian"; then
  echo "*******该脚本不支持该操作系统，请手动安装*******"
  exit
fi

# 用户选择安装的jdk版本 默认jdk8
echo "请选择需要安装的jdk版本(默认安装jdk8)"
echo "jdk7 请输入：7"
echo "jdk8 请输入：8"
echo "jdk10 请输入：10"
read -p "请输入：" val
if [  ! -n "$val" ]; then
    echo "*******开始下载默认jdk8*******"
    if [ "$arch" -eq 32 ]; then
      jdk=jdk-8u171-linux-i586.tar.gz
      wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  -P /var/tmp/jdk "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/$jdk"
    else
      jdk=jdk-8u171-linux-x64.tar.gz
      wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -P /var/tmp/jdk "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/$jdk"
    fi
elif [ "$val" -eq 7 ]; then
    echo "*******开始下载jdk7*******"
    if [ "$arch" -eq 32 ]; then
      jdk=jdk-7u80-linux-i586.tar.gz
      # 由于oracle官网需要登录下载jdk7 则现在从cos下载
      wget http://dev-1251506639.cossh.myqcloud.com/jdk/jdk7/"$jdk" -P /var/tmp/jdk
    else
      jdk=jdk-7u80-linux-x64.tar.gz
      wget http://dev-1251506639.cossh.myqcloud.com/jdk/jdk7/"$jdk" -P /var/tmp/jdk
    fi
elif [ "$val" -eq 8 ];then
    echo "*******开始下载jdk8*******"
     if [ "$arch" -eq 32 ]; then
      jdk=jdk-8u171-linux-i586.tar.gz
      wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  -P /var/tmp/jdk "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/$jdk"
    else
      jdk=jdk-8u171-linux-x64.tar.gz
      wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -P /var/tmp/jdk "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/$jdk"
    fi
elif [ "$val" -eq 10 ];then
    echo "*******开始下载jdk10*******"
    if [ "$arch" -eq 32 ]; then
      echo "*******jdk10不支持32位操作系统，请选择64位安装*******"
    else
      jdk=jdk-10.0.1_linux-x64_bin.tar.gz
      wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -P /var/tmp/jdk "http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/$jdk"
    fi
else
    echo "请输入有效的数字"
    echo ""
    exit
fi

#tar mv /usr/local/jdk
echo "*******开始解压*******"
echo "解压$jdk 到安装目录/usr/local/jdk/"
mkdir /usr/local/jdk
tar xzf /var/tmp/jdk/"$jdk" -C /usr/local/jdk/ && rm -rf /var/tmp/jdk/"$jdk"

# PATH
echo ""
echo "*******添加环境变量*******"
cd /usr/local/jdk/jdk*
home=$(cd `dirname $0`; pwd)
echo "*******JAVA_HOME=${home}*******"
echo ""
echo "#JAVA_HOME" >> /etc/profile
echo "JAVA_HOME=${home}" >> /etc/profile
echo "CLASSPATH=\$JAVA_HOME/lib" >> /etc/profile
echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile

echo "*******安装结束********"
echo ""
echo "请手动执行命令：source /etc/profile "
