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
-export([start_link/0, init/1, handle_call/3, put/2, get/1, handle_cast/2]).

start_link() ->
  logger:info("gen_server: Starting"),
  gen_server:start_link({global, node()}, ?MODULE, [], []).

put(Key, Value) ->
  Node = data_distributor:node_for(Key),
  logger:info("router: Forwarding put. key: ~w to node: ~w", [Key, Node]),
  gen_server:call({global, Node}, {put, Key, Value}).

get(Key) ->
  Node = data_distributor:node_for(Key),
  logger:info("router: Forwarding get. key: ~w to node: ~w", [Key, Node]),
  gen_server:call({global, Node}, {get, Key}).

init([]) ->
  {ok, #{}}.

handle_call({put, Key, Value}, _From, State) ->
  logger:info("gen_server: Putting key: ~w value: ~w", [Key, Value]),
  {reply, ok, maps:put(Key, Value, State)};

handle_call({get, Key}, _From, State) ->
  logger:info("gen_server: Getting key: ~w", [Key]),
  {reply, get_if_exists(Key, State), State}.

get_if_exists(Key, Map) ->
   case maps:is_key(Key, Map) of
     true -> maps:get(Key, Map);
     _ -> <<"not_existing_key">>
   end.

handle_cast(_Request, _State) ->
  erlang:error(not_implemented).