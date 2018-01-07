%%%-------------------------------------------------------------------
%%% @author mkuzmik
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. Dec 2017 13:34
%%%-------------------------------------------------------------------
-module(command_parser).
-author("mkuzmik").

%% API
-export([extract_key/1, extract_key_value/1]).

extract_key(Content) ->
  Key = trim(Content),
  Key.

extract_key_value(Content) ->
  KeyVal = trim(Content),
  [Key, Val] = binary:split(KeyVal, <<" ">>),
  {Key, Val}.

trim(Bin) when is_binary(Bin) ->
  list_to_binary(trim(binary_to_list(Bin)));
trim(String) when is_list(String) ->
  String2 = lists:dropwhile(fun is_whitespace/1, String),
    lists:reverse(lists:dropwhile(fun is_whitespace/1, lists:reverse(String2))).

is_whitespace($\s)-> true;
is_whitespace($\t)-> true;
is_whitespace($\n)-> true;
is_whitespace($\r)-> true;
is_whitespace(_Else) -> false.