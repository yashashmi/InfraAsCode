#!/bin/bash
set -e

SECRETFILE=.digitalocean
if [[ -z $DIGOCEAN_ID ]] || [[ -z $DIGOCEAN_KEY ]]; then
    if [ -e $SECRETFILE ]; then
        . $SECRETFILE
    fi
fi

if [[ -z $DIGOCEAN_ID ]] || [[ -z $DIGOCEAN_KEY ]]; then
    echo "You need to set the environment variables DIGOCEAN_ID and DIGOCEAN_KEY"
    echo "or provide them in the file $SECRETFILE"
    exit 1
fi

BASE_URL='https://api.digitalocean.com/v2'
AUTH="$DIGOCEAN_KEY"

echo "DIGOCEAN_KEY is $AUTH"

REGION_NAME="Bangalore 1"
SIZE_NAME="1gb"
IMAGE_NAME="20.04 (LTS) x64"

REGION_ID=`curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH" "$BASE_URL/v2/regions" | jq ".regions | map(select(.name==\"$REGION_NAME\"))[0].slug"`

echo "ID of Region $REGION_NAME is $REGION_ID"

# SIZE_ID=`curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH" "$BASE_URL/v2/sizes" | jq ".sizes | map(select(.name==\"$SIZE_NAME\"))[0].id"`
# echo "ID of Size $SIZE_NAME is $SIZE_ID"

# IMAGE_ID=`curl -s "$BASE_URL/images?$AUTH" | jq ".images | map(select(.name==\"$IMAGE_NAME\"))[0].id"`
# echo "ID of Image $IMAGE_NAME is $IMAGE_ID"

#REGION_ID="blr1"
SIZE_ID="s-1vcpu-1gb"
IMAGE_ID="72067660"

# SSH_KEY_ID=`curl -s "$BASE_URL/ssh_keys?$AUTH" | jq '.ssh_keys[0].id'`
# echo "Activating SSH Key with ID $SSH_KEY_ID"

SSH_KEY_ID="29001989"

TIMESTAMP=`date '+%Y%m%d%H%M%S'`
DROPLET_NAME="droplet-$TIMESTAMP"

echo "Creating new Droplet $DROPLET_NAME with these specifications..."
RESULT=`curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH" -d '{"name":'$DROPLET_NAME',"region":'$REGION_ID',"size":'$SIZE_ID',"image":'$IMAGE_ID',"ssh_keys":'$SSH_KEY_ID',"backups":false,"ipv6":true,"user_data":null,"private_networking":null,"volumes": null,"tags":["web"]}' "$BASE_URL/droplets"`
STATUS=`echo $RESULT | jq -r '.status'`
echo "Status: $STATUS"
if [ "$STATUS" != "OK" ]; then
    echo "Something went wrong:"
    echo $RESULT | jq .
    exit 1
fi
DROPLET_ID=`echo $RESULT | jq '.droplet.id'`
echo "Droplet with ID $DROPLET_ID created!"

echo "Waiting for droplet to boot"
for i in {1..60}; do
    DROPLET_STATUS=`curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH" "$BASE_URL/droplets/$DROPLET_ID" | jq -r '.droplet.status'`
    [ "$DROPLET_STATUS" == 'active' ] && break
    echo -n '.'
    sleep 5
done
echo

if [ "$DROPLET_STATUS" != 'active' ]; then
    echo "Droplet did not boot in time. Status: $DROPLET_STATUS"
    exit 1
fi

IP_ADDRESS=`curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $AUTH" "$BASE_URL/droplets/$DROPLET_ID" | jq -r '.droplet.ip_address'`

echo "Execute bootstrap script"
BOOTSTRAP_URL="UpdateUbuntuDroplet.sh"
SSH_OPTIONS="-o StrictHostKeyChecking=no"
ssh $SSH_OPTIONS root@$IP_ADDRESS "curl -s $BOOTSTRAP_URL | bash"

echo "*****************************"
echo "* Droplet is ready to use!"
echo "* IP address: $IP_ADDRESS"
echo "*****************************"
