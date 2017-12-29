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
-export([node_for/1]).

hash_of(Key) ->
  [X|_] = binary_to_list(crypto:hash(md4, Key)),
  X.

node_for(Key) ->
  SortedNodes = lists:sort(lists:concat([nodes(), [node()]])),
  NodesAmount = length(SortedNodes),
  Hash = hash_of(Key),
  NodeNum = Hash rem NodesAmount,
  lists:nth(NodeNum + 1, SortedNodes).
