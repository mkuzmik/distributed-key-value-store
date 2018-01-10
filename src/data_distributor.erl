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
-export([node_for/1, nodes_for/1]).

hash_of(Key) ->
  [X|_] = binary_to_list(crypto:hash(md4, Key)),
  X.

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
