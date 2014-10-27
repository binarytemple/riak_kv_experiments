```
[/common/riak_kv_experiments%]erl -pa ebin deps/**/ebin
Erlang R15B01 (erts-5.9.1) [source] [64-bit] [smp:8:8] [async-threads:0] [kernel-poll:false]

Eshell V5.9.1  (abort with ^G)
1> m(eleveldb).
Module eleveldb compiled: Date: October 27 2014, Time: 18.37
Compiler options:  [{outdir,"ebin"},
                    debug_info,warnings_as_errors,
                    {parse_transform,lager_transform},
                    {d,'TEST_FS2_BACKEND_IN_RIAK_KV'},
                    {i,"include"}]
Object file: /common/riak_kv_experiments/deps/eleveldb/ebin/eleveldb.beam
Exports:
close/1                       iterator_move/2
delete/3                      module_info/0
destroy/2                     module_info/1
fold/4                        open/2
fold_keys/4                   option_types/1
get/3                         put/4
is_empty/1                    repair/2
iterator/2                    status/2
iterator/3                    validate_options/2
iterator_close/1              write/3
ok

3> eleveldb:open("/tmp/plop",[]).
{error,{db_open,"Invalid argument: /tmp/plop: does not exist (create_if_missing is false)"}}
4> eleveldb:open("/tmp/plop",[{create_if_missing,true}]).
{ok,<<>>}
5> eleveldb:close("/tmp/plop").
** exception error: bad argument
     in function  eleveldb:close/1
        called as eleveldb:close("/tmp/plop")

2> X = eleveldb:open("/tmp/plop",[{create_if_missing,true}]).
{ok,<<>>}

3> {ok,E} = eleveldb:open("/tmp/plop",[{create_if_missing,true}]).
** exception error: no match of right hand side value
                    {error,{db_open,"IO error: lock /tmp/plop/LOCK: already held by process"}}

4> {ok,E} = eleveldb:open("/tmp/plop2",[{create_if_missing,true}]).
{ok,<<>>}

5> eleveldb:write(E,"sda","sad").
{error,#Ref<0.0.0.62>,{bad_write_action,115}}

6> eleveldb:write(E,<<"sda">>,<<"sad">>).
** exception error: bad argument
     in function  eleveldb:async_write/4
        called as eleveldb:async_write(#Ref<0.0.0.66>,<<>>,<<"sda">>,<<"sad">>)
     in call from eleveldb:write/3 (src/eleveldb.erl, line 155)

7> eleveldb:put(E,<<"sda">>,<<"sad">>).
** exception error: undefined function eleveldb:put/3

8> eleveldb:put(E,<<"sda">>,<<"sad">>,[]).
ok
9> eleveldb:put(E,<<"sda">>,<<"sad">>,[]).
ok
10> eleveldb:put(E,<<"sda">>,<<"sad">>,[]).
ok
11> eleveldb:put(E,<<"sda">>,<<"sad">>,[]).
ok
12> eleveldb:get(E,<<"sda">>,<<"sad">>).
** exception error: bad argument
     in function  eleveldb:async_get/4
        called as eleveldb:async_get(#Ref<0.0.0.90>,<<>>,<<"sda">>,<<"sad">>)
     in call from eleveldb:get/3 (src/eleveldb.erl, line 143)
13> eleveldb:get(E,<<"sda">>,<<"sad">>,[]).
** exception error: undefined function eleveldb:get/4

14> eleveldb:get(E,<<"sda">>,<<"sad">>).
** exception error: bad argument
     in function  eleveldb:async_get/4
        called as eleveldb:async_get(#Ref<0.0.0.98>,<<>>,<<"sda">>,<<"sad">>)
     in call from eleveldb:get/3 (src/eleveldb.erl, line 143)
15> eleveldb:get(E,<<"sda">>,[]).
{ok,<<"sad">>}

16> eleveldb:status(E,[]).
** exception error: bad argument
     in function  eleveldb:status/2
        called as eleveldb:status(<<>>,[])
17> eleveldb:status(E,<<"sda">>).
error

18> eleveldb:status(E).
** exception error: undefined function eleveldb:status/1

19> eleveldb:status(E,[]).
** exception error: bad argument
     in function  eleveldb:status/2
        called as eleveldb:status(<<>>,[])

20> eleveldb:status(E,<<"sda">>).
error
24> lists:foldl([1,3,2,4],fun(X,Y) -> Y end, []).
** exception error: no function clause matching lists:foldl([1,3,2,4],#Fun<erl_eval.12.82930912>,[]) (lists.erl, line 1196)

25> lists:foldl(fun(X,Y) -> Y end, [], []).
[]
26> lists:foldl(fun(X,Y) -> Y end, [], [1,3,3]).
[]
27> lists:foldl(fun(X,Y) -> Y end, [1,3,4], [1,3,3]).
[1,3,4]
28> lists:foldl(fun(X,Y) -> Y end, [1,3,4], []).
[1,3,4]
29> lists:foldl(fun(X,Y) -> Y + 1 end, [1,3,4], []).
[1,3,4]

31> lists:foldl(fun(X,Y) -> X + 1 end, [], [1,3,4]).
5

32> lists:foldl(fun(X,Y) -> X + 1 end, [1], [1,3,4]).
5

33> lists:foldl(fun(X,Y) -> [X + 1 | Y]  end, [], [1,3,4]).
[5,4,2]

34> lists:foldr(fun(X,Y) -> [X + 1 | Y]  end, [], [1,3,4]).
[2,4,5]

35> eleveldb:fold_keys(E,fun(X) -> X end,[], [] ).
** exception error: interpreted function with arity 1 called with two arguments
     in function  eleveldb:fold_loop/4 (src/eleveldb.erl, line 313)
     in call from eleveldb:do_fold/4 (src/eleveldb.erl, line 303)

36> eleveldb:fold_keys(E,fun(X,Y) -> X end,[], [] ).
<<"sda">>
37> eleveldb:fold_keys(E,fun(X,Y) -> X end,[], [] ).
<<"sda">>

38> eleveldb:put(E,<<"sdda">>,<<"sad">>,[]).
ok
39> eleveldb:put(E,<<"s333dda">>,<<"sad">>,[]).
ok
40> eleveldb:fold_keys(E,fun(X,Y) -> X end,[], [] ).
<<"sdda">>
41> eleveldb:fold_keys(E,fun(X,Y) -> X end,[], [] ).
<<"sdda">>
42> eleveldb:fold_keys(E,fun(X,Y) -> Y end,[], [] ).
[]
43> eleveldb:fold_keys(E,fun(X,Y) -> X end,[], [] ).
<<"sdda">>
44> eleveldb:fold_keys(E,fun(X,Y) -> [X|Y] end,[], [] ).
[<<"sdda">>,<<"sda">>,<<"s333dda">>]
45> eleveldb:fold_keys(E,fun(X,Y) -> [X|Y] end,[], [] ).
[<<"sdda">>,<<"sda">>,<<"s333dda">>]
46> eleveldb:fold_keys(E,fun(X,Y) -> [X|Y] end,[], [] ).
[<<"sdda">>,<<"sda">>,<<"s333dda">>]

27: lists:foldl(fun(X, Y) ->
                       Y
                end,
                [1,3,4],
                [1,3,3])
-> [1,3,4]
28: lists:foldl(fun(X, Y) ->
                       Y
                end,
                [1,3,4],
                [])
-> [1,3,4]
29: lists:foldl(fun(X, Y) ->
                       Y + 1
                end,
                [1,3,4],
                [])
-> [1,3,4]
30: lists:foldl(fun(X, Y) ->
                       Y + 1
                end,
                [],
                [1,3,4])
-> {'EXIT',{badarith,[{erlang,'+',[[],1],[]},
                      {lists,foldl,3,[{file,"lists.erl"},{line,1197}]},
                      {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,576}]},
                      {shell,exprs,7,[{file,"shell.erl"},{line,668}]},
                      {shell,eval_exprs,7,[{file,"shell.erl"},{line,623}]},
                      {shell,eval_loop,3,[{file,"shell.erl"},{line,608}]}]}}

31: lists:foldl(fun(X, Y) ->
                       X + 1
                end,
                [],
                [1,3,4])
-> 5

32: lists:foldl(fun(X, Y) ->
                       X + 1
                end,
                [1],
                [1,3,4])
-> 5

33: lists:foldl(fun(X, Y) ->
                       [X + 1|Y]
                end,
                [],
                [1,3,4])
-> [5,4,2]

34: lists:foldr(fun(X, Y) ->
                       [X + 1|Y]
                end,
                [],
                [1,3,4])
-> [2,4,5]

35: eleveldb:fold_keys(E,
                       fun(X) ->
                              X
                       end,
                       [],
                       [])
-> {'EXIT',{{badarity,{#Fun<erl_eval.6.82930912>,
                       [<<"sda">>,[]]}},
            [{eleveldb,fold_loop,4,
                       [{file,"src/eleveldb.erl"},{line,313}]},
             {eleveldb,do_fold,4,[{file,"src/eleveldb.erl"},{line,303}]},
             {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,576}]},
             {shell,exprs,7,[{file,"shell.erl"},{line,668}]},
             {shell,eval_exprs,7,[{file,"shell.erl"},{line,623}]},
             {shell,eval_loop,3,[{file,"shell.erl"},{line,608}]}]}}

36: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              X
                       end,
                       [],
                       [])
-> <<"sda">>
37: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              X
                       end,
                       [],
                       [])
-> <<"sda">>
38: eleveldb:put(E, <<"sdda">>, <<"sad">>, [])
-> ok
39: eleveldb:put(E, <<"s333dda">>, <<"sad">>, [])
-> ok
40: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              X
                       end,
                       [],
                       [])
-> <<"sdda">>
41: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              X
                       end,
                       [],
                       [])
-> <<"sdda">>
42: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              Y
                       end,
                       [],
                       [])
-> []
43: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              X
                       end,
                       [],
                       [])
-> <<"sdda">>
44: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              [X|Y]
                       end,
                       [],
                       [])
-> [<<"sdda">>,<<"sda">>,<<"s333dda">>]
45: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              [X|Y]
                       end,
                       [],
                       [])
-> [<<"sdda">>,<<"sda">>,<<"s333dda">>]
46: eleveldb:fold_keys(E,
                       fun(X, Y) ->
                              [X|Y]
                       end,
                       [],
                       [])
-> [<<"sdda">>,<<"sda">>,<<"s333dda">>]
ok
48>

```
