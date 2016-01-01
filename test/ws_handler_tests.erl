-module(ws_handler_tests).

-include_lib("eunit/include/eunit.hrl").


setup() ->
    {ok, Started1} = application:ensure_all_started(sand),
    {ok, Started2} = application:ensure_all_started(gun),
    Started1 ++ Started2.


cleanup(Started) ->
    [application:stop(App) || App <- Started],
    ok.


all_test_() ->
    {foreach,
     fun setup/0,
     fun cleanup/1,
     [
      fun handler_success/0
     ]
    }.


handler_success() ->
    {ok, Pid} = gun:open("localhost", 8080),
    {ok, http} = gun:await_up(Pid),
    _MRef = gun:ws_upgrade(Pid, <<"/ws">>),
    receive
        {gun_ws_upgrade, Pid, ok, _Headers} ->
            ok = gun:ws_send(Pid, {text, <<"count">>}),
            ?debugHere,
            receive
                {gun_ws, Pid, {text, <<"0">>}} ->
                    ok = gun:ws_send(Pid, {text, <<"count">>}),
                    receive
                        {gun_ws, Pid, {text, <<"1">>}} ->
                            ok = gun:ws_send(Pid, {text, <<"count">>}),
                            receive
                                {gun_ws, Pid, {text, <<"2">>}} ->
                                    ok = gun:ws_send(Pid, {text, <<"reset_count">>}),
                                    receive
                                        {gun_ws, Pid, {text, <<"0">>}} ->
                                            ok
                                    end
                            end
                    end
            end
    end.
