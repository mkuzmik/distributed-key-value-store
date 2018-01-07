#!/bin/sh

# $1 argument is node name
# $2 argument is master node name

set -x
set -e

erl -noshell -config config/* -boot start_sasl -pa ebin -name $1 -setcookie abc -kernel inet_dist_listen_min 9000 inet_dist_listen_max 9005 -run store_app start 1234 $2