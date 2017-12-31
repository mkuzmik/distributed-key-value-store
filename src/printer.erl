%%%-------------------------------------------------------------------
%%% @author mkuzmik
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. Dec 2017 12:05
%%%-------------------------------------------------------------------
-module(printer).
-author("mkuzmik").

%% API
-export([print_map/1]).

print_map(Map) ->
  case maps:size(Map) of
    0 -> <<"Empty\n">>;
    _ -> list_to_binary(maps:fold(fun (Key, Value, Acc) ->
      io_lib:format(Acc ++ "~s  =>  ~s~n", [Key, Value]) end, "", Map))
  end.
