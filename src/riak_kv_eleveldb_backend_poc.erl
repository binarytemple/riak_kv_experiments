-module(riak_kv_eleveldb_backend_poc).
-export([init/0]).
-define(MD_INDEX, <<"index">>).

%% [
%% {<<"field_bin">>, <<"A">>},
%% {<<"field_int">>, 1}
%% ]


%%
-type index_spec() :: {binary(), (binary() | integer())}.
-spec create_object(riak_object:bucket(), riak_object:key(), term(), [index_spec()]) -> {ok, term()}.
create_object(Bucket, Key, Val, IndexData) ->
  io:format("create_object ~p ~p ~p ~p ~n", [Bucket, Key, Val, IndexData]),
  Obj = riak_object:new(Bucket, Key, Val),
  io:format("Obj ~p ~n", [Obj]),
  Obj1 = riak_object:update_metadata(Obj,
    dict:store(<<"index">>, IndexData,
      dict:new())),
  {ok, riak_object:apply_updates(Obj1)}
.

init() ->
  io:format("keys_example leveldb ~n", []),

  application:load(eleveldb),

  {ok, State} = riak_kv_eleveldb_backend:start(0, [
    {max_open_files, 100},
    {compression, false},
    {data_root, "itest2"}
  ]),

  Big = lists:foldl(fun(I, Acc) -> [round(random:uniform() * 100) * I | Acc] end, [], lists:seq(1, 100)),

  io:format("Big ~p", [Big]),
  io:format("backend_status: ~p ~n", [riak_kv_eleveldb_backend:status(State)]),
  io:format("backend is empty : ~p ~n", [riak_kv_eleveldb_backend:is_empty(State)]),
  io:format("state: ~p ~n", [State]),
  try
    io:format("in the block  ~n", []),
    {ok, Obj} = create_object(<<"foo">>, <<"bar">>, Big, [{<<"name_bin">>, <<"dogs">>}, {<<"num_int">>, 1}]),
    {ok, NewState} =
      riak_kv_eleveldb_backend:put(
        <<"test">>, <<"test">>,
        riak_object:index_specs(Obj),
        riak_object:to_binary(v1, Obj), State),

    io:format("new state: ~p ~n", [NewState]),
    io:format("finished the block  ~n", [])
  catch
    E:F -> io:format("[error]: caught ~p ~p ", [E, F])
  after
    riak_kv_eleveldb_backend:stop(State)
  end,
  io:format("finished playtime with leveldb ~n", []),

  timer:apply_after(1, leveldb_poc, die, ["finished"]),
  ok.

die(Reason) ->
  erlang:exit(Reason)
.
