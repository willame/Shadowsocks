
以下启动脚本均假定shadowsocks-rss安装于/usr/local/shadowsocks目录，配置文件为/usr/local/shadowsocks/user-config.json，请按照实际情况自行修改

SysVinit启动脚本，适合CentOS/RHEL6系以及Ubuntu 14.x，Debian7.x

```
#!/bin/sh
# chkconfig: 2345 90 10
# description: Start or stop the Shadowsocks R server
#
### BEGIN INIT INFO
# Provides: Shadowsocks-R
# Required-Start: $network $syslog
# Required-Stop: $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: Start or stop the Shadowsocks R server
### END INIT INFO

# Author: Yvonne Lu(Min) <min@utbhost.com>

name=shadowsocks
PY=/usr/bin/python
SS=/usr/local/shadowsocks/server.py
SSPY=server.py
conf=/usr/local/shadowsocks/user-config.json

start(){
    $PY $SS -c $conf -d start
    RETVAL=$?
    if [ "$RETVAL" = "0" ]; then
        echo "$name start success"
    else
        echo "$name start failed"
    fi
}

stop(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i "${SSPY}" | awk '{print $2}'`
    if [ ! -z $pid ]; then
        $PY $SS -c $conf -d stop
        RETVAL=$?
        if [ "$RETVAL" = "0" ]; then
            echo "$name stop success"
        else
            echo "$name stop failed"
        fi
    else
        echo "$name is not running"
        RETVAL=1
    fi
}

status(){
    pid=`ps -ef | grep -v grep | grep -v ps | grep -i "${SSPY}" | awk '{print $2}'`
    if [ -z $pid ]; then
        echo "$name is not running"
        RETVAL=1
    else
        echo "$name is running with PID $pid"
        RETVAL=0
    fi
}

case "$1" in
'start')
    start
    ;;
'stop')
    stop
    ;;
'status')
    status
    ;;
'restart')
    stop
    start
    RETVAL=$?
    ;;
*)
    echo "Usage: $0 { start | stop | restart | status }"
    RETVAL=1
    ;;
esac
exit $RETVAL
```
粘贴复制运行之后，报错


```
env: /etc/init.d/shadowsocks: No such file or directory
```

原因是


```
Carriage return characters have been inserted into your init script. Shell scripts may not be read correctly when unexpected carriage returns are encountered. Typically this might occur when the file was created via a Windows system, text editor, or terminal, as Windows uses carriage return + line feed characters for line endings, whereas *nix systems only use line feed characters
```
解决方法

Remove the carriage return characters from the init script. This can be done with a sed one-liner
This will remove the carriage return characters, after which you can start the service successfully
```
sed -i -e 's/\r//g' /etc/init.d/your_init_script
```
[原文在这里](https://confluence.atlassian.com/kb/starting-service-on-linux-throws-a-no-such-file-or-directory-error-794203722.html)
