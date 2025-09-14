counter=1

while true; do
    logger "hello $counter"
    ((counter++))
    sleep 5
done