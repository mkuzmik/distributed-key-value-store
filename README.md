# Distibuted Key-Value Store

## What is it?
Implementation of key-value store running on many Erlang nodes. Its main goal is 'write-read anywhere' design, which means that you can write data to one node and read it from any node from cluster.

## Requirements

- Erlang OTP
- Rebar 2

## Starting app
- `rebar clean compile`
- `erl -pa ebin`
- `store_app:start().`

## Authors
- Mateusz Kuźmik
- Szymon Jakóbczyk