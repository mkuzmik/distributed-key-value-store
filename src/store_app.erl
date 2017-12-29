-module(store_app).

-behaviour(application).

%% Application callbacks
-export([start/1, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(Port) ->
    application:set_env(store, app_port, Port),
    application:start(store).

start(_StartType, _StartArgs) ->
    logger:info("Starting application"),
    store_sup:start_link().

stop(_State) ->
    ok.