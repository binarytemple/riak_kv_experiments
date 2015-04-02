-module(leveldb_poc_utils).

-export([itterate_example/0, folding_example/0, get_put_example/0,die_soon/2]).
-define(MD_INDEX, <<"index">>).

itterate_example() ->
  io:format("playtime with leveldb ~n", []),
  os:cmd("rm -rf ltest"),  % NOTE
  {ok, Ref} = eleveldb:open("ltest", [{create_if_missing, true}]),
  try
    eleveldb:put(Ref, <<"a">>, <<"x">>, []),
    eleveldb:put(Ref, <<"b">>, <<"y">>, []),
    {ok, I} = eleveldb:iterator(Ref, []),
    {ok, <<"a">>, <<"x">>} == eleveldb:iterator_move(I, <<>>),
    {ok, <<"b">>, <<"y">>} == eleveldb:iterator_move(I, next),
    {ok, <<"a">>, <<"x">>} == eleveldb:iterator_move(I, prev)
  after
    eleveldb:close(Ref)
  end,
  io:format("finished playtime with leveldb ~n", []),
  erlang:exit("finished"),
  ok.

folding_example() ->
  io:format("playtime with leveldb ~n", []),
  {ok, State} = riak_kv_eleveldb_backend:start(0, []),
  io:format("state: ~p ~n", [State]),
  try
    io:format("in the block  ~n", []),
    riak_kv_eleveldb_backend:put(<<"foo">>, <<"bar">>, [], <<"dsadfa">>, State),
    {ok, D, _} = riak_kv_eleveldb_backend:get(<<"foo">>, <<"bar">>, State),
    io:format("retrieved ~p  ~n", [D]),
    Keys = riak_kv_eleveldb_backend:fold_keys(fun(X, Y, Z) ->
      io:format("folded over ~p ~p ~p ~n", [X, Y, Z]),
      [] end, [], [], State),
    io:format("finished the block  ~n", [])
  after
    riak_kv_eleveldb_backend:stop(State)
  end,
  io:format("finished playtime with leveldb ~n", []),
  erlang:exit("finished"),
  ok.

get_put_example() ->
  io:format("playtime with leveldb ~n", []),
  {ok, State} = riak_kv_eleveldb_backend:start(0, []),
  io:format("state: ~p ~n", [State]),
  try
    io:format("in the block  ~n", []),
    riak_kv_eleveldb_backend:put(<<"foo">>, <<"bar">>, [], <<"dsadfa">>, State),
    {ok, D, _} = riak_kv_eleveldb_backend:get(<<"foo">>, <<"bar">>, State),
    io:format("retrieved ~p  ~n", [D]),
    Keys = riak_kv_eleveldb_backend:fold_keys(fun(X, Y, Z) ->
      io:format("folded over ~p ~p ~p ~n", [X, Y, Z]),
      [] end, [], [], State),
    io:format("finished the block  ~n", [])
  after
    riak_kv_eleveldb_backend:stop(State)
  end,
  io:format("finished playtime with leveldb ~n", []),
  erlang:exit("finished"),
  ok.


die_soon(Time,Reason) ->
  timer:apply_after(Time, ?MODULE , die,[Reason]),
erlang:exit(Reason)
.