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
-export([info/1, warn/1, error/1]).

info(Msg) ->
  io:format("INFO : "),
  print_node(),
  io:format("~s~n", [Msg]).

warn(Msg) ->
  io:format("WARN : "),
  print_node(),
  io:format("~s~n", [Msg]).

error(Msg) ->
  io:format("ERROR : "),
  print_node(),
  io:format("~s~n", [Msg]).

print_node() ->
  io:format("~w : ", [node()]).