-module(sand_ws_handler).

-behaviour(cowboy_websocket).

-export([init/2,
         websocket_handle/3,
         websocket_info/3]).

-record(state, {count :: non_neg_integer()}).


init(Req, _Opts) ->
    {cowboy_websocket, Req, #state{count = 0}}.


websocket_handle({text, <<"count">>}, Req, #state{count = Count} = State) ->
    CountBin = integer_to_binary(Count),
    {reply, {text, <<CountBin/binary>>}, Req, State#state{count = Count + 1}};
websocket_handle({text, <<"reset_count">>}, Req, State) ->
    {reply, {text, <<"0">>}, Req, State#state{count = 0}};
websocket_handle(_InFrame, Req, State) ->
    {stop, Req, State}.


websocket_info(_OutFrame, Req, State) ->
    {stop, Req, State}.
