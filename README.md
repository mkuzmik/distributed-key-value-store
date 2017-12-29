# Distributed Key-Value Store

## What is it?
Implementation of key-value store running on many Erlang nodes. Its main goal is 'write-read anywhere' design, which means that you can write data to one node and read it from any node from cluster.

## Requirements
- Erlang OTP
- Rebar 2

## Starting app

#### 1. Open terminals
Open at least one terminal (depends on how many nodes you want to have). Go to project root directory.

#### 2. Compile application
Execute `rebar clean compile` in one terminal.

#### 3. Start Erlang nodes.
Execute `erl -pa ebin -sname <your_node_name>` in each terminal. `<your_node_name>` must be unique for each node. Then Erlang shell will be opened.

#### 4. Connect nodes with each other.
In one shell execute `net_kernel:connect_node(<another_node_name>)` for each node. You can check connected node by `nodes()` command.

#### 5. Set ports for application tcp interface
Set application environment variable app_port for each node (all port must differ): `application:set_env(store, app_port, <port>)`

#### 6. Start application
On all nodes execute: `application:start(store).`

## Using app

- Connect to any node by telnet: 
```bash
telnet localhost <choosen_port>
```
- Use commands:
```bash
put <key> <value>;
get <key>;
quit
```

## Todo
- Storing data on specific node (depends on key hash)

## Problems
- Updating new node with current data

## Authors
- Mateusz Kuźmik
- Szymon Jakóbczyk