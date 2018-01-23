-module(tcp_interface).

%% API
-export([start_server/1]).

start_server(Port) ->
  Pid = spawn_link(fun() ->
    {ok, Listen} = gen_tcp:listen(Port, [binary, {active, false}]),
    spawn(fun() ->
      logger:info("tcp_interface: Started on port: ~w", [Port]),
      acceptor(Listen) end),
    timer:sleep(infinity)
                   end),
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
      logger:info("tcp_interface: Lost connection"),
      gen_tcp:close(Socket);
    {tcp, Socket, <<"getall", Content/binary>>} ->
      handle_get_all(Socket, Content),
      handle(Socket);
    {tcp, Socket, <<"get", Content/binary>>} ->
      handle_get(Socket, Content),
      handle(Socket);
    {tcp, Socket, <<"put", Content/binary>>} ->
      handle_put(Socket, Content),
      handle(Socket);
    {tcp, Socket, <<"help", Content/binary>>} ->
      handle_help(Socket, Content),
      handle(Socket);
    {tcp, Socket, _} ->
      gen_tcp:send(Socket, <<"Error: Unknown command\n">>),
      handle(Socket)
  end.

handle_get_all(Socket, Content) ->
  try command_parser:extract_key(Content) of
    <<"node">> -> gen_tcp:send(Socket, printer:print_map(store_node:get_all_from_node()));
    <<"all">> -> gen_tcp:send(Socket, printer:print_map(store_node:get_all()));
    _ -> gen_tcp:send(Socket, printer:print_map(store_node:get_all()))
  catch
    _:_ -> gen_tcp:send(Socket, <<"Error: invalid getall command\n">>)
  end.

handle_put(Socket, Content) ->
  try command_parser:extract_key_value(Content) of
    {Key, Value} ->
      store_node:put(Key, Value),
      gen_tcp:send(Socket, <<"ok\n">>)
  catch
    _:_ -> gen_tcp:send(Socket, <<"Error: invalid put command\n">>)
  end.

handle_get(Socket, Content) ->
  try command_parser:extract_key(Content) of
    Key -> gen_tcp:send(Socket, [store_node:get(Key), <<"\n">>])
  catch
    _:_ -> gen_tcp:send(Socket, <<"Error: invalid get command">>)
  end.

handle_help(Socket, Content) ->
  gen_tcp:send(Socket, help()).

help() ->
  <<"
  Commands:\n
  put <key> <value>\n
  get <key>\n
  getall node - get all data stored only on current node\n
  getall - get all data from whole cluster\n
  quit\n">>.

