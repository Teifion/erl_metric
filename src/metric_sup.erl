-module(metric_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/1, init/1]).

-spec start_link() -> {ok, pid()}.
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(MetricName) ->
  supervisor:start_child(metric_sup, [MetricName]).

init(_) ->
    SupFlags = #{
      strategy => simple_one_for_one,
      intensity => 0,
      period => 1
    },
    ChildSpecs = [#{id => metric_server,
                    start => {metric_server, start_link, []},
                    restart => permanent,
                    shutdown => brutal_kill}],
    {ok, {SupFlags, ChildSpecs}}.
