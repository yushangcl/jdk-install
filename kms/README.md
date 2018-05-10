# KMS Server

`version 0.1.1`
`20180504`

It is a Shell Script which can build a KMS Server automatically.

`HOW TO USE`

```
wget --no-check-certificate -O kms.sh https://raw.githubusercontent.com/yushangcl/shell-install/master/kms/kms.sh && chmod +x kms.sh && bash kms.sh
```

---

The following hardware platforms and operating systems are supported. More  hardware platforms and operating systems are coming.

| Hardware Platform | Operating System            |
| ----------------- | --------------------------- |
| x86/i386          | Debian、Ubuntu、CentOS        |
| x86-64/amd64      | Debian、Ubuntu、CentOS、Deepin |
| Raspberry pi      | Raspbian                    |

#### Active Windows
```bash
slmgr.vbs /upk
slmgr.vbs /ipk 激活码
slmgr.vbs /skms ip:1688 
slmgr.vbs /ato
slmgr.vbs /dlv
```

#### Active Office
```bash
cscript ospp.vbs /dstatus 执行该命令后显示激活码识别号
Last 5 characters of installed product key: XXXXX
cscript ospp.vbs /unpkey:取上面的识别号
cscript ospp.vbs /inpkey:激活码
cscript ospp.vbs /sethst:ip:1688
cscript ospp.vbs /act
```

##### firewall
```bash
iptables -I INPUT -m state —state NEW -m tcp -p tcp —dport 1688 -j ACCEPT

iptables -I INPUT -m state —state NEW -m udp -p udp —dport 1688 -j ACCEPT
```
active key:
https://technet.microsoft.com/en-us/library/jj612867.aspx


msdn address
http://www.itellyou.cn/

> (Binaries from https://forums.mydigitallife.net/threads/emulated-kms-servers-on-non-windows-platforms.50234/)