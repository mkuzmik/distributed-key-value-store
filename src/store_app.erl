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
    start([_Port, MasterNode, "1"]);

start([_Port, MasterNode, ReplicationFactor]) ->
    true = connect_to_cluster(MasterNode),
    config:set_replication_factor(ReplicationFactor),
    config:set_port(_Port),
    application:start(store).

connect_to_cluster(MasterNode) ->
    net_kernel:connect_node(list_to_atom(MasterNode)).

start(_StartType, [MasterNode]) ->
    io:format("Args: ~w~n", [MasterNode]),
    true = net_kernel:connect_node(MasterNode),
    start(_StartType, []);

start(_StartType, _StartArgs) ->
    logger:info("Starting application"),
    store_sup:start_link().

stop(_State) ->
    ok.