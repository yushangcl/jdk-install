#!/usr/bin/env bash
#!/usr/bin/env bash
#URL: https://github.com/yushangcl/jdk-install
#E-mail: gayhub@live.cn
clear
echo "    ################################################"
echo "    #                                              #"
echo "    #                  Build JDK10                 #"
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
echo "*******开始下载jdk-10.0.1-linux*******"
rm -rf /var/tmp/jdk/*
if cat /etc/*-release | grep -Eqi "raspbian"; then
  echo "*******该脚本不支持该操作系统，请手动安装*******"
  exit
else
  if [ "$arch" -eq 32 ]; then
    echo "*******jdk10不支持32位操作系统，请选择64位安装*******"
  else
    jdk=jdk-10.0.1_linux-x64_bin.tar.gz
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -P /var/tmp/jdk "http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/$jdk"
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



