-module(printer).

%% API
-export([print_map/1]).

print_map(Map) ->
  case maps:size(Map) of
    0 -> <<"Empty\n">>;
    _ -> list_to_binary(maps:fold(fun (Key, Value, Acc) ->
      io_lib:format(Acc ++ "~s  =>  ~s~n", [Key, Value]) end, "", Map))
  end.
