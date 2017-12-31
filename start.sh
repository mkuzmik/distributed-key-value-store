#!/bin/bash

# set -e
# set -x

# default port
port=1234
# default amount of nodes
nodes=1

while [ $# -ge 1 ]
do
    case "$1" in
        "--port" | "-p")  port="$2";;
        "--nodes" | "-n") nodes="$2";;
    esac
    shift 2
done

rebar clean compile
printf "\n\n"

ports=""
counter=1
masternode=$counter
while [ $counter -le $nodes ]
do
    echo "Starting node $counter@`hostname` with store tcp interface on port $port"
    erl -noshell -boot start_sasl -pa ebin -sname $counter -s store_app start $port $masternode@`hostname` -detached
    ((counter++))
    ports="$ports $port"
    ((port++))
done

printf "\n\nConnect to nodes by any of following commands:"
for p in $ports
do
    echo "telnet localhost $p"
done