# Start your shell 

```
[/basho/riak/dev/dev1%]./erts-5.10.4/bin/erl
```

# Console time

```
55> bitcask:open("/basho/riak/dev/dev1/data/fast_bitcask/593735040165679310520246963290989976735222595584/").
.... million errors
{error,{init_keydir_scan_key_files,too_many_iterations}}
```

# Need to clear some bitcask state before continuing... I didn't...

```
55> Ref = bitcask:open("/basho/riak/dev/dev1/data/fast_bitcask/593735040165679310520246963290989976735222595584").
** exception error: no match of right hand side value {error,timeout}
56> q().
ok
```

# Back we go again, subsequently learned I could have called ...

```
 erlang:erase(bitcask_efile_port).
```

# Anyhow, I'm back in the shell getting some data's

```
Erlang R16B03 (erts-5.10.4) [source] [64-bit] [smp:8:8] [async-threads:10] [kernel-poll:false]

Eshell V5.10.4  (abort with ^G)
1> l(bitcask).
{module,bitcask}

3> Ref = bitcask:open("/basho/riak/dev/dev1/data/fast_bitcask/936274486415109681974235595958868809467081785344").
#Ref<0.0.0.122>

5> Keys = bitcask:list_keys(Ref).
[<<3,0,4,102,97,115,116,0,3,102,111,111,49,54,55,50,53>>,
 <<3,0,4,102,97,115,116,0,3,102,111,111,49,57,50,55>>,
 <<3,...>>,
 <<...>>|...]

11> [ H | T ] = Keys.
[<<3,0,4,102,97,115,116,0,3,102,111,111,49,54,55,50,53>>,
 <<3,0,4,102,...>>,
 <<3,0,4,...>>,
 <<3,0,...>>,
 <<3,...>>,
 <<...>>|...]
12> H.
<<3,0,4,102,97,115,116,0,3,102,111,111,49,54,55,50,53>>
13> erlang:binary_to_list(H).
[3,0,4,102,97,115,116,0,3,102,111,111,49,54,55,50,53]

15> {ok, Data} = bitcask:get(Ref,H).
{ok,<<53,1,0,0,0,34,131,108,0,0,0,1,104,2,109,0,0,0,8,
      197,82,177,11,84,46,87,228,...>>}

17> l(riak_object).
{module,riak_object}

```

Digression, time to fuck up the bitcask system, and clear it out

```
30>  erlang:erase(bitcask_efile_port).
#Port<0.1051>
31>  erlang:erase(bitcask_efile_port).
undefined
32> Ref = bitcask:open("/basho/riak/dev/dev1/data/fast_bitcask/936274486415109681974235595958868809467081785344").
** exception error: no match of right hand side value #Ref<0.0.0.295>
33> f(Ref).
ok
```
See if we can find out anything about that object

```

38> bitcask:is_tombstone(H).
false

49> erlang:length(erlang:binary_to_list( Data )).
251

```
Dump it to a file and open with vim... yeah ... looks legit

```

57> {ok,Blah} = file:open("/tmp/blah",[write]).
{ok,<0.123.0>}
58> file:write(Blah,Data).
ok
59> file:close(Blah).


```

#Check is it a riak_object... yay v1
```

69> riak_object:binary_version(Data).
v1
```
Bring it back into a structured form... the first two parameters are supposed to be bucket and key... I just set them to random names...

```
70> riak_object:from_binary(foo,bar,Data).
{r_object,foo,bar,
          [{r_content,{dict,7,16,16,8,80,48,
                            {[],[],[],[],[],[],[],[],[],[],[],[],[],[],...},
                            {{[],[],
                              [[<<"Links">>]],
                              [],
                              [[<<"dot">>|{<<"ÅR±\vT.Wä">>,{1,63579575733}}]],
                              [],[],[],[],[],
                              [[...]|...],
                              [...],...}}},
                      <<"16732">>}],
          [{<<"ÅR±\vT.Wä">>,{1,63579575733}}],
          {dict,1,16,16,8,80,48,
                {[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],...},
                {{[],[],[],[],[],[],[],[],[],[],[],[],[],...}}},
          undefined}

```
Get it's actual value

```

72> riak_object:get_value(RObject).
<<"16732">>

```

