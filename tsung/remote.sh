#! /bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
KEY="~/.ssh/SupremePotato.pem"

scp -i "$KEY" "$DIR/orders.xml" "$DIR/userlist.csv" "ec2-user@$1:"
ssh -i "$KEY" "ec2-user@$1" tsung -kf orders.xml start
