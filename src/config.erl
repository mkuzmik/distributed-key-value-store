%%%-------------------------------------------------------------------
%%% @author mateusz-kuzmik
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jan 2018 12:23
%%%-------------------------------------------------------------------
-module(config).
-author("mateusz-kuzmik").

%% API
-export([set_port/1, get_port/0, set_replication_factor/1, get_replication_factor/0]).

set_replication_factor(RepFac) when is_list(RepFac) ->
  set_replication_factor(list_to_integer(RepFac));

set_replication_factor(RepFac) when is_integer(RepFac) ->
  application:set_env(store, replication_factor, RepFac).

get_replication_factor() ->
  {ok, RepFac} = application:get_env(store, replication_factor),
  RepFac.

set_port(Port) when is_list(Port) ->
  set_port(list_to_integer(Port));

set_port(Port) when is_integer(Port) ->
  application:set_env(store, app_port, Port).

get_port() ->
  {ok, Port} = application:get_env(store, app_port),
  Port.