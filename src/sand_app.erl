-module(sand_app).

-behaviour(application).

-export([start/2
        ,stop/1]).

start(_StartType, _StartArgs) ->
    start_http(),
    sand_sup:start_link().


stop(_State) ->
    ok.


start_http() ->
    Dispatch = cowboy_router:compile([
        {'_', [{"/hello", sand_hello_handler, []},
               {"/ws", sand_ws_handler, []}
              ]}
    ]),
    cowboy:start_http(sand_http,
                      100,
                      [{port, 8080}],
                      [{env, [{dispatch, Dispatch}]}]).
