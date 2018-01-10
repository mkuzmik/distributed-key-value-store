#!/bin/bash

# set -e
# set -x

# cleanup
./kill_all_nodes.sh

# default port
port=1234
# default amount of nodes
nodes=1
detached="-detached"

while [ $# -ge 1 ]
do
    case "$1" in
        "--port" | "-p")  port="$2"; shift 2;;
        "--nodes" | "-n") nodes="$2"; shift 2;;
        "--shell" | "-s") detached=""; shift;;
    esac
done

rebar clean compile
printf "\n\n"

ports=""
counter=1
masternode=$counter
while [ $counter -le $nodes ]
do
    echo "Starting node $counter@`hostname` with store tcp interface on port $port"
    erl -kernel error_logger "{file, \"./logs/$counter@`hostname`.log\"}" -boot start_sasl -pa ebin -sname $counter -run store_app start $port $masternode@`hostname` $detached
    ((counter++))
    ports="$ports $port"
    ((port++))
done

printf "\n\nConnect to nodes by any of following commands:\n"
for p in $ports
do
    printf "telnet localhost $p\n"
done