%%%-------------------------------------------------------------------
%%% @author mateusz-kuzmik
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Jan 2018 21:34
%%%-------------------------------------------------------------------
-module(health_control).
-author("mateusz-kuzmik").
-behavior(gen_server).

%% API
-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
  gen_server:start_link({global, node()}, ?MODULE, [], []).

init([]) ->
  logger:info("health control: Initialization."),
  lists:map(fun(Node) ->
    gen_server:call({global, Node}, {synchronize}) end, nodes()),
  {ok, data_distributor:node_table()}.

handle_call({synchronize}, _From, State) ->
  logger:info("health control: synchronization started"),
  {noreply, State}.

handle_cast(Request, State) ->
  erlang:error(not_implemented).

handle_info(Info, State) ->
  {noreply, State}.

terminate(Reason, State) ->
  ok.

code_change(OldVsn, State, Extra) ->
  {ok, State}.