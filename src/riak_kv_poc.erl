-module(riak_kv_poc).

-export([hello/0]).

hello() ->
  application:set_env(riak_kv, storage_backend, bitcask),
%%   app_helper:set_env(riak_kv, storage_backend, bitcask),
  {ok, Pid} = riak_kv_app:start(foo,bar),
 ok.

