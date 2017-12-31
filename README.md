# Distributed Key-Value Store

## What is it?
Implementation of key-value store running on many Erlang nodes. Its main goal is 'write-read anywhere' design, which means that you can write data to one node and read it from any node from cluster.

## Requirements
- Erlang OTP
- Rebar 2

## Starting app

### Start app automatically (using bash script)

#### 1. Open terminal and execute start.sh

Execute `start.sh` script in your terminal. In parameters you may describe number of nodes and  TCP port for first node
(if you specify 3 nodes and port 1000, nodes will get 1000, 1001 and 1002 ports).

Examples:

- `./start.sh`  -> creates one node on port 1234
- `./start.sh --port 1000`  -> creates one node on port 1000
- `./start.sh --nodes 2 -port 1000`  -> creates two nodes on port 1000 and 1001
- `./start.sh -n 2 -p 1000`  -> same as above (shortened parameter names)

### Start app manually (better for debugging cases)

#### 1. Open terminals
Open at least one terminal (depends on how many nodes you want to have). Go to project root directory.

#### 2. Compile application
Execute `rebar clean compile` in one terminal.

#### 3. Start Erlang nodes.
Execute `erl -pa ebin -sname <your_node_name>` in each terminal. `<your_node_name>` must be unique for each node. Then Erlang shell will be opened.

#### 4. Connect nodes with each other.
In one shell execute `net_kernel:connect_node(<another_node_name>)` for each node. You can check connected node by `nodes()` command.

#### 6. Start application
On all nodes execute: `store_app:start(<port>)`. Each node must run on unique port.

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
- Nodes synchronization
- Data replication
- Saving data on hard drive (Redis?)
- Prettify logging
- Make commands in tcp_interface more readable (+ add help command)

## Problems
- Connecting new node to existing cluster

## Authors
- Mateusz Kuźmik
- Szymon Jakóbczyk