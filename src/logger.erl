-module(logger).

%% API
-export([info/1, info/2, warn/1, warn/2, error/1, error/2]).

info(Msg) ->
  error_logger:info_msg(Msg).

info(Msg, Params) ->
  error_logger:info_msg(Msg, Params).

warn(Msg) ->
  error_logger:warning_msg(Msg).

warn(Msg, Params) ->
  error_logger:warning_msg(Msg, Params).

error(Msg) ->
  error_logger:error_msg(Msg).

error(Msg, Params) ->
  error_logger:error_msg(Msg, Params).