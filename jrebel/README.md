# JRebelServer
`version 0.4.1`
`20180504`

It is a Shell Script which can build a JRebel Server automatically.

`HOW TO USE`

```
wget --no-check-certificate -O jrebel.sh https://raw.githubusercontent.com/yushangcl/JRebelServer/master/jrebel.sh && chmod +x jrebel.sh && bash jrebel.sh
```

---

The following hardware platforms and operating systems are supported. More  hardware platforms and operating systems are coming.

| Hardware Platform | Operating System            |
| ----------------- | --------------------------- |
| x86/i386          | Debian、Ubuntu、CentOS        |
| x86-64/amd64      | Debian、Ubuntu、CentOS、Deepin |
| Raspberry pi      | Raspbian                    |

##### Client
> Group URL :http://ip:1018/[guid]

> Email Address：all email is ok

##### firewall
```bash
iptables -I INPUT -m state —state NEW -m tcp -p tcp —dport 1018 -j ACCEPT

iptables -I INPUT -m state —state NEW -m udp -p udp —dport 1018 -j ACCEPT
```
active key:
https://technet.microsoft.com/en-us/library/jj612867.aspx


msdn address
http://www.itellyou.cn/

> (Binaries from https://forums.mydigitallife.net/threads/emulated-kms-servers-on-non-windows-platforms.50234/)