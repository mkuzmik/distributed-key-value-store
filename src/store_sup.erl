-module(store_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, [
        {node,
            {store_node, start_link, []},
            permanent, brutal_kill, worker, [store_node]},
        {tcp,
            {tcp_interface, start_server, [config:get_port()]},
            permanent, brutal_kill, worker, [tcp_interface]}
    ]} }.

