-module(store_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/1, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    start(1234).

start(Port) when is_integer(Port) ->
    application:set_env(store, app_port, Port),
    application:start(store);

start([_Port]) ->
    Port = util:atom_to_integer(_Port),
    application:set_env(store, app_port, Port),
    application:start(store);

start([_Port, MasterNode]) ->
    io:format("Args: ~w ~w~n", [_Port, MasterNode]),
    true = net_kernel:connect_node(MasterNode),
    start([_Port]).

start(_StartType, _StartArgs) ->
    logger:info("Starting application"),
    store_sup:start_link().

stop(_State) ->
    ok.