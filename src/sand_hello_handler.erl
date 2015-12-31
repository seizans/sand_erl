-module(sand_hello_handler).

-behaviour(cowboy_handler).

-export([init/2]).


init(Req, _Opts) ->
    case cowboy_req:method(Req) of
        <<"GET">> ->
            Body = <<"Hello !!">>,
            Req2 = cowboy_req:reply(200, [], Body, Req),
            {ok, Req2, undefined};
        _Other ->
            Req2 = cowboy_req:reply(405, Req),
            {ok, Req2, undefined}
    end.
