-module(store_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    store_app:start([],[]).

start(_StartType, _StartArgs) ->
    store_sup:start_link().

stop(_State) ->
    ok.
