%%%-------------------------------------------------------------------
%%% @author mkuzmik
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Dec 2017 13:59
%%%-------------------------------------------------------------------
-module(data_distributor).
-author("mkuzmik").

%% API
-export([node_for/1, nodes_for/1, node_table/0, nodes_for/2, sorted_hash_node_list/1, pos_of/2]).

hash_of(Key) when is_binary(Key) ->
  [X|_] = binary_to_list(crypto:hash(md4, Key)),
  X;

hash_of(Node) when is_atom(Node) ->
  hash_of(atom_to_binary(Node, utf8)).

nodes_for(Key) ->
  NodeTable = node_table(),
  NodesAmount = length(NodeTable),
  Hash = hash_of(Key),
  NodeNum = Hash rem NodesAmount + 1,
  ReplicationFactor = config:get_replication_factor(),
  util:nths(NodeNum, ReplicationFactor, node_table()).

node_for(Key) ->
  util:random_element(nodes_for(Key)).

node_table() ->
  lists:sort(lists:concat([nodes(), [node()]])).

nodes_for(Key, NodeTable) ->
  HashNodeList = sorted_hash_node_list(NodeTable),
  KeyHash = hash_of(Key),
  ReplicationFactor = config:get_replication_factor(),
  lists:map(fun({_, Node}) -> Node end,
    util:nths(pos_of(KeyHash, HashNodeList), ReplicationFactor, HashNodeList)).

pos_of(KeyHash, HashNodeSortedList) ->
  lists:foldr(fun({Hash, _}, Iter) ->
    case KeyHash > Hash of
      false -> Iter;
      _ -> Iter + 1
    end end, 1, HashNodeSortedList).

sorted_hash_node_list(Nodes) ->
  L = lists:map(fun(Node) -> {hash_of(Node), Node} end, Nodes),
  lists:sort(L).
