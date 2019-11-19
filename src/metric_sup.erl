-module(metric_sup).
-behaviour(supervisor).

-export([start_link/0, start_child/1, init/1]).

-spec start_link() -> {ok, pid()}.
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

% JAKUB
% Looking at http://erlang.org/doc/design_principles/sup_princ.html#simplified-one_for_one-supervisors
% there is nothing saying how to pass an argument to the children being started
% the implication at one stage is the 2nd argument would do it but that is elsewhere shown
% to hold the ID of the child being started
start_child(MetricName) ->
  supervisor:start_child(metric_sup, [metric_server]).


init(_) ->
    SupFlags = #{
      strategy => simple_one_for_one,
      intensity => 0,
      period => 1
    },
    ChildSpecs = [#{id => metric_server,
                    start => {metric_server, sthtart_link, []},
                    shutdown => brutal_kill}],
    {ok, SupFlags, ChildSpecs}.
