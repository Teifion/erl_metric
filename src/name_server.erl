-module(name_server).
-behaviour(gen_server).

% We store the name of the metric against the process PID in ETS

init([]) -> {ok, gb_trees:empty()}.

register_name (metric_name) ->
  pass.

get_name (metric_name) ->
  pass.
