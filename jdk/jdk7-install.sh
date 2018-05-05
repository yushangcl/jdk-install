#!/usr/bin/env bash
#URL: https://github.com/yushangcl/shell-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #                  Build JDK7                  #"
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

#download JDK 7
echo "*******开始下载jdk-7u80-linux*******"
rm -rf /var/tmp/jdk/*
if cat /etc/*-release | grep -Eqi "raspbian"; then
  echo "*******该脚本不支持该操作系统，请手动安装*******"
  exit
else
  if [ "$arch" -eq 32 ]; then
    jdk=jdk-7u80-linux-i586.tar.gz
    # 由于oracle官网需要登录下载jdk7 则现在从cos下载
    wget http://dev-1251506639.cossh.myqcloud.com/jdk/jdk7/"$jdk" -P /var/tmp/jdk
  else
    jdk=jdk-7u80-linux-x64.tar.gz
    wget http://dev-1251506639.cossh.myqcloud.com/jdk/jdk7/"$jdk" -P /var/tmp/jdk
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



