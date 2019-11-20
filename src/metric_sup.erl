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
  % http://erlang.org/doc/man/supervisor.html#SupRef
  supervisor:start_child(metric_sup, [{local, MetricName}]).
  
% Get these working for tomorrow
% rebar test
% rebar eunit

init(_) ->
    SupFlags = #{
      strategy => simple_one_for_one,
      intensity => 0,
      period => 1
    },
    % TODO find a param in the child spec which will dictate the lifecycle/duration of the 
    % child so we can say they last indefinately (keywords: transient, permenant, temporary)
    % may also have to specify worker vs supervisor
    ChildSpecs = [#{id => metric_server,
                    start => {metric_server, start_link, []},
                    shutdown => brutal_kill}],
    {ok, SupFlags, ChildSpecs}.
