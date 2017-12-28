%%%-------------------------------------------------------------------
%%% @author mkuzmik
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Dec 2017 13:00
%%%-------------------------------------------------------------------
-module(store_node).
-author("mkuzmik").

-behavior(gen_server).

%% API
-export([start_link/0, init/1, handle_call/3, put/2, get/1]).

start_link() ->
  io:format("I'm starting ~s~n", [node()]),
  gen_server:start_link({global, node()}, ?MODULE, [], []).

put(Key, Value) ->
  lists:map(fun (TempNode) ->
    gen_server:call({global, TempNode}, {put, Key, Value}) end, nodes()),
  gen_server:call({global, node()}, {put, Key, Value}).

get(Key) ->
  gen_server:call({global, node()}, {get, Key}).

init([]) ->
  {ok, #{}}.

handle_call({put, Key, Value}, From, State) ->
  {reply, ok, maps:put(Key, Value, State)};
handle_call({get, Key}, From, State) ->
  {reply, maps:get(Key, State), State}.