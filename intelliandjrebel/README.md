# license-install
`version 0.1.1`
`20180504`

It is a Shell Script which can build a Jrebel IntelliJ license Server automatically.

`HOW TO USE`

license install
```
wget --no-check-certificate -O license-install.sh https://raw.github.com/yushangcl/shell-install/master/intelliandjrebel/license-install.sh && chmod +x license-install.sh && bash license-install.sh
```


Docker 
```bash
docker pull logr/idea-jrebel
```
```
docker run -d --name lincese  -p 8081:8081 logr/idea-jrebel java -jar license.jar
```