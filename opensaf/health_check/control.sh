start() {   
    start-stop-daemon --start --background \
        --make-pidfile --pidfile /var/run/demo.pid \
        --exec /opt/demo/main
}

stop() {    
    start-stop-daemon --stop --pidfile /var/run/demo.pid
}

case $1 in
    start)
        start;;
    stop)
        stop;;
    *)
        echo 'Usage: control.sh {start|stop}'
        exit 1;;
esac

exit 0
