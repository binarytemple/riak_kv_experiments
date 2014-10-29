-module(riak_kv_eleveldb_backend_poc).
-export([init/0]).
-define(MD_INDEX, <<"index">>).

%% [
%% {<<"field_bin">>, <<"A">>},
%% {<<"field_int">>, 1}
%% ]
create_object(Bucket, Key, Val, MetaDataList) ->
  io:format("create_object ~p ~p ~p ~p ~n", [Bucket, Key, Val, MetaDataList]),
%%   dict:new()
  riak_object:new(Bucket, Key, Val, dict:new())
%%  riak_object:new(Bucket, Key, Val, dict:from_list([{?MD_INDEX, MetaDataList}]) )
.

die(Reason) ->
  erlang:exit(Reason)
.

init() ->
  io:format("keys_example leveldb ~n", []),
%%   Obj  = create_object(<<"a">>,<<"b">>,<<"bar">>,  [{<<"field_bin">>, <<"A">>}]),
  Obj = create_object(<<"a">>, <<"b">>, <<"bar">>, []),
  io:format("object ~p ~n", [Obj]),

%%   app_helper:  get_prop_or_env(data_root, Config, eleveldb)


  %% This is where everything breaks ;-)
  {ok, State} = riak_kv_eleveldb_backend:start(0, [
    {data_root, "ltest2", eleveldb}
  ]),
  io:format("state: ~p ~n", [State]),
  try
    io:format("in the block  ~n", []),
%% riak_kv_eleveldb_backend:put(<<"foo">>, <<"bar">>, [{add, {<<"field_int">>, 1}}], <<"dsadfa">>, State),
%%    riak_kv_eleveldb_backend:put(<<"a">>, <<"b">>, [], <<"asdfa">>, State),
    riak_kv_eleveldb_backend:put(<<"a">>, <<"b">>, [], Obj, State),
%%     {ok, D, _} = riak_kv_eleveldb_backend:get(<<"foo">>, <<"bar">>, State),
%%     io:format("retrieved ~p  ~n", [D]),
%%     Keys = riak_kv_eleveldb_backend:fold_keys(fun(X, Y, Z) ->
%%       io:format("folded over ~p ~p ~p ~n", [X, Y, Z]),
%%       [] end, [], [], State),
    io:format("finished the block  ~n", [])
  catch
    _:E -> io:format("caught ~p ", [E])
  after
    riak_kv_eleveldb_backend:stop(State)
  end,
  io:format("finished playtime with leveldb ~n", []),
%%   timer:apply_after(1, leveldb_poc, die, ["finished"]),
  ok.