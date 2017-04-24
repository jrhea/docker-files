#!/bin/bash
#Prereqs:
# OSX, socat, XQuartz
#Usage:
# ./vpn.sh [ID] [PASSWORD] [ACCESS_CODE] [VPN_SERVER] [CONTAINER_NAME] [CONTAINER_IP] [CONTAINER_SSH_PORT] [REMOTE_DESKTOP_NAME]
#Example:
# ./vpn.sh plq8203 mypassword myaccesscode vpnserver jrhea/openconnect 192.168.65.1 2200 L6026097

keepgoing=1
trap '{ echo "sigint"; keepgoing=0; }' SIGINT

ID=$1
PASSWORD=$2
ACCESS_CODE=$3
SERVER=$4
CONTAINER_NAME=$5
CONTAINER_IP=$6
CONTAINER_SSH_PORT=$7
REMOTE_DESKTOP_NAME=$8
# start XServer 
open -a XQuartz

# Expose local xquartz socket via socat on a TCP port
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" > /dev/null &
PID_SOCAT=$!
echo "SOCAT PID: $PID_SOCAT"
echo "pgrep socat:" 
pgrep socat 
# Run openconnect container
docker run --privileged \
-p 127.0.0.1:$CONTAINER_SSH_PORT:22 \
-e SSH_PUB="$(cat ~/.ssh/id_rsa.pub)" \
-e OPTIONS="-u $ID --authgroup=AnyConnect_Client --no-cert-check" \
-e SERVER=$SERVER \
-e PASSWORD=$PASSWORD$ACCESS_CODE \
-e DISPLAY=$CONTAINER_IP:0 \
-t $CONTAINER_NAME &

# sleep 10 seconds to allow for vpn connection to be established (I could output to a named pipe and monitor it until it connects)
sleep 10s

CONTAINER_ID=$(docker ps -a -q | head -n1)
echo "Container_ID: $CONTAINER_ID"

if [ "$REMOTE_DESKTOP_NAME" ]; then
  ssh -Y -p $CONTAINER_SSH_PORT root@127.0.0.1 "rdesktop -g 100% -u $ID $REMOTE_DESKTOP_NAME"
fi

while (( keepgoing )); do
    sleep 1s
done

function finish {
 echo "stopping container $CONTAINER_ID"
 docker stop $CONTAINER_ID
 docker rm $CONTAINER_ID
 #echo "stopping socat process $PID_SOCAT"
 #kill $PID_SOCAT
}
trap finish EXIT
