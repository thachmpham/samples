  

start() {
    logger -st demo 'start'

    # start-stop-daemon --start --background \
    #     --make-pidfile --pidfile /var/run/demo.pid \
    #     --exec /opt/demo/main

    start-stop-daemon --start --background \
        --make-pidfile --pidfile /var/run/demo.pid \
        --exec /usr/bin/gdbserver localhost:5555 /opt/demo/main
}

stop() {
    logger -st demo 'stop'

    # start-stop-daemon --stop --pidfile /var/run/demo.pid
    
    kill -9 $(cat /var/run/demo.pid)
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

  