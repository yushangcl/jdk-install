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

#检测是否已经安装java环境
echo ""
JAVA_VERSION=`java -version 2>&1 | head -1`
if [[ "$JAVA_VERSION" == java* ]]; then
    echo "检测到已安装的Java版本：$JAVA_VERSION"
    echo ""
    which=`which java`
    echo "安装路径为 $which "
    echo ""
else
    echo "未检测到Java环境，是否安装Java环境?（y/n）"
    read -p "请输入：" val
    if [ "$val" -eq "y" ]; then
        echo ""

     else
        echo "退出安装！"
        exit

    fi
fi