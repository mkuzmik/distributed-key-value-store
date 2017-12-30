%%%-------------------------------------------------------------------
%%% @author mkuzmik
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Dec 2017 13:16
%%%-------------------------------------------------------------------
-module(logger).
-author("mkuzmik").

%% API
-export([info/1, info/2, warn/1, warn/2, error/1, error/2]).

info(Msg) ->
  io:format("INFO : "),
  print_node(),
  io:format("~s~n", [Msg]).

info(Msg, Params) ->
  FormatMsg = io_lib:format(Msg, Params),
  info(FormatMsg).

warn(Msg) ->
  io:format("WARN : "),
  print_node(),
  io:format("~s~n", [Msg]).

warn(Msg, Params) ->
  FormatMsg = io_lib:format(Msg, Params),
  warn(FormatMsg).

error(Msg) ->
  io:format("ERROR : "),
  print_node(),
  io:format("~s~n", [Msg]).

error(Msg, Params) ->
  FormatMsg = io_lib:format(Msg, Params),
  logger:error(FormatMsg).

print_node() ->
  io:format("~w : ", [node()]).