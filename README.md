# Distributed Key-Value Store

## What is it?
Implementation of key-value store running on many Erlang nodes. Its main goal is 'write-read anywhere' design, which means that you can write data to one node and read it from any node from cluster.

## Requirements
- Erlang OTP
- Rebar 2

## Starting app
1. `rebar clean compile`
2. `erl -pa ebin -sname <your_node_name>`
3. `application:start(store).`

## Todo
- TCP node interface
- Storing data on specific node (depends on key hash)
- Travis CI setup

## Authors
- Mateusz Kuźmik
- Szymon Jakóbczyk