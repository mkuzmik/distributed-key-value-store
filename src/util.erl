%%%-------------------------------------------------------------------
%%% @author mkuzmik
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. Dec 2017 11:33
%%%-------------------------------------------------------------------
-module(util).
-author("mkuzmik").

%% API
-export([atom_to_integer/1, random_element/1, nths/3]).



atom_to_integer(Port) ->
  binary_to_integer(atom_to_binary(Port, utf8)).

random_element(List) ->
  Index = random:uniform(length(List)),
  lists:nth(Index, List).

nths(Index, Amount, List) ->
  lists:foldl(
    fun(El, Res) ->
      ElementIndex = (Index + El - 2) rem length(List) + 1,
      lists:append([Res, [lists:nth(ElementIndex, List)]])
      end,
    [],
    lists:seq(1, Amount)
  ).




