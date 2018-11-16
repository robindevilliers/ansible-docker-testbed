#!/bin/bash

docker network create --subnet=172.19.0.0/16 rainbow-network

servers=("red" "orange" "yellow" "green" "blue" "indigo" "violet" "brown" "pink" "purple" )
ports=( "2201" "2202" "2203" "2204" "2205" "2206" "2207" "2008" "2009" "2010")

echo deleting existing servers
echo =========================
for i in "${servers[@]}"
do
   docker rm $i -f
done

echo creating new containers
echo =======================

for ((i = 0; i < ${#servers[@]}; ++i)); do
    HOST=${servers[$i]}
    echo Host: $HOST ${ports[$i]}
    docker run --privileged  -ti -d -p ${ports[$i]}:22 --net rainbow-network -h $HOST --name $HOST rainbow
done

rm ~/.ssh/config.rainbow

for ((i = 0; i < ${#servers[@]}; ++i)); do
    HOST=${servers[$i]}
    PORT=${ports[$i]}
    echo $HOST $PORT
    echo -e "Host $HOST\n HostName localhost\n User deploy\n Port $PORT\n" >> ~/.ssh/config.rainbow
    ssh-keygen -R [localhost]:$PORT >> /dev/null
    sshpass -p deploy ssh-copy-id $HOST -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no
done









