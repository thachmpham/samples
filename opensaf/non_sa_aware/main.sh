program='/opt/demo/loop.sh'
pidfile='/var/run/demo.pid'

start() {
    echo 'demo starting...'
    logger 'demo starting...'

    start-stop-daemon --start --background \
        --make-pidfile --pidfile $pidfile \
        --exec /bin/bash -- $program

    echo 'demo started'
    logger 'demo started'
}

stop() {
    echo 'demo stopping...'
    logger 'demo stopping...'

    start-stop-daemon --stop --pidfile $pidfile \
        --retry 5

    echo 'stopped'
    logger 'demo stopped'
}

status() {
    if [ -f $pidfile ] \
        && start-stop-daemon --status --pidfile $pidfile;\
    then
        echo "running, pid: $(cat $pidfile)"
    else
        echo 'not running'
    fi
}

case $1 in
    start)
        start;;
    stop)
        stop;;
    status)
        status;;
    *)
        echo 'Usage: main.sh {start|stop|status}'
        exit 1;;
esac

exit 0
  