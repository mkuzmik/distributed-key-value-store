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
-export([atom_to_integer/1]).

atom_to_integer(Port) ->
  binary_to_integer(atom_to_binary(Port, utf8)).