%%%-------------------------------------------------------------------
%%% @author mkuzmik
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Dec 2017 09:08
%%%-------------------------------------------------------------------
-module(tcp_interface).
-author("mkuzmik").

%% API
-export([start_server/1]).

start_server(Port) ->
  Pid = spawn_link(fun() ->
    {ok, Listen} = gen_tcp:listen(Port, [binary, {active, false}]),
    spawn(fun() -> acceptor(Listen) end),
    timer:sleep(infinity)
                   end),
  logger:info("tcp_interface: Started on port: ~w", [Port]),
  {ok, Pid}.

acceptor(ListenSocket) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  logger:info("tcp_interface: Got connection"),
  spawn(fun() -> acceptor(ListenSocket) end),
  handle(Socket).

handle(Socket) ->
  inet:setopts(Socket, [{active, once}]),
  receive
    {tcp, Socket, <<"quit", _/binary>>} ->
      gen_tcp:close(Socket);
    {tcp, Socket, <<"get ", Content/binary>>} ->
      handle_get(Socket, Content),
      handle(Socket);
    {tcp, Socket, <<"put ", Content/binary>>} ->
      handle_put(Socket, Content),
      handle(Socket);
    {tcp, Socket, <<"getall ", Content/binary>>} ->
      handle_get_all(Socket, Content),
      handle(Socket);
    {tcp, Socket, <<"\n">>} ->
      gen_tcp:send(Socket, <<"\n">>);
    {tcp, Socket, _} ->
      gen_tcp:send(Socket, <<"unknown command \n">>),
      handle(Socket)
  end.

handle_get_all(Socket, Params) ->
  case binary:split(Params, <<";">>) of
    [<<"node">>|_] -> gen_tcp:send(Socket, printer:print_map(store_node:get_all_from_node()));
    [<<"all">>|_] -> gen_tcp:send(Socket, printer:print_map(store_node:get_all()));
    _ -> gen_tcp:send(Socket, printer:print_map(store_node:get_all()))
  end.

handle_put(Socket, KeyVal) ->
  [Key, ValPart] =
    case binary:split(KeyVal, <<" ">>) of
      [K,V] -> [K,V];
      [K] -> [K, <<"">>];
      _ -> [<<"">>, <<"">>]
    end,
  [Val | _] = binary:split(ValPart, <<";">>),
  store_node:put(Key, Val),
  gen_tcp:send(Socket, <<"ok\n">>).

handle_get(Socket, KeyPart) ->
  [Key | _] = binary:split(KeyPart, <<";">>),
  gen_tcp:send(Socket, [store_node:get(Key), <<"\n">>]).
