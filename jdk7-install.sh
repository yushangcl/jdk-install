#!/usr/bin/env bash
#URL: https://github.com/yushangcl/jdk-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #                  Build JDK7                  #"
echo "    #            https://blog.itbat.cn             #"
echo "    #                Version 0.4.1                 #"
echo "    ################################################"
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
echo "*******开始下载jdk-7u171-linux*******"
rm -rf /var/tmp/jdk/*
if cat /etc/*-release | grep -Eqi "raspbian"; then
  echo "*******该脚本不支持该操作系统，请手动安装*******"
  exit
else
  if [ "$arch" -eq 32 ]; then
    jdk=jdk-8u171-linux-i586.tar.gz
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  -P /var/tmp/jdk "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/$jdk"
  else
    jdk=jdk-8u171-linux-x64.tar.gz
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -P /var/tmp/jdk "http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/$jdk"
  fi
fi

#tar mv /usr/local/jdk
echo "*******解压$jdk 安装目录/usr/local/jdk/*******"
mkdir /usr/local/jdk
tar xzf /var/tmp/jdk/"$jdk" -C /usr/local/jdk/ && rm -rf /var/tmp/jdk/"$jdk"

# PATH
echo "*******添加环境变量*******"
cd /usr/local/jdk/jdk*
home=$(cd `dirname $0`; pwd)
echo "JAVA_HOME=${home}" >> /etc/profile
echo "CLASSPATH=\$JAVA_HOME/lib" >> /etc/profile
echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile

echo "*******安装结束********"
echo "请手动执行命令：source /etc/profile "



