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
-export([get_all_from_node/0, get_all_from_node/1, get_all/0, start_link/0, init/1, handle_call/3, put/2, get/1, handle_cast/2]).

start_link() ->
  logger:info("store_node: Starting"),
  gen_server:start_link({global, node()}, ?MODULE, [], []).

put(Key, Value) ->
  Node = data_distributor:node_for(Key),
  logger:info("router: Forwarding put. key: ~w to node: ~w", [Key, Node]),
  gen_server:call({global, Node}, {put, Key, Value}).

get(Key) ->
  Node = data_distributor:node_for(Key),
  logger:info("router: Forwarding get. key: ~w to node: ~w", [Key, Node]),
  gen_server:call({global, Node}, {get, Key}).

get_all_from_node(Node) ->
  gen_server:call({global, Node}, {all_from_node}).

get_all_from_node() ->
  get_all_from_node(node()).

get_all() ->
  logger:info("Getting ALL command started"),
  AllNodes = lists:sort(lists:concat([nodes(), [node()]])),
  Result = lists:foldl(fun (Node, Result) ->
    logger:info("Getting ALL command in progress. Getting from node: ~w", [Node]),
    NodeMap = get_all_from_node(Node),
    maps:merge(NodeMap, Result) end, #{}, AllNodes),
  logger:info("Getting ALL command completed"),
  Result.

init([]) ->
  {ok, #{}}.

handle_call({put, Key, Value}, _From, State) ->
  logger:info("store_node: Putting key: ~s value: ~s", [Key, Value]),
  {reply, ok, maps:put(Key, Value, State)};

handle_call({get, Key}, _From, State) ->
  logger:info("store_node: Getting key: ~s", [Key]),
  {reply, get_if_exists(Key, State), State};

handle_call({all_from_node}, _From, State) ->
  logger:info("store_node: Getting ALL from this node"),
  {reply, State, State}.

get_if_exists(Key, Map) ->
   case maps:is_key(Key, Map) of
     true -> maps:get(Key, Map);
     _ -> <<"__not_existing_key__">>
   end.

handle_cast(_Request, _State) ->
  erlang:error(not_implemented).