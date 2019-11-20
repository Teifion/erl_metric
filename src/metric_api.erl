-module (metric_api).

-export([report/2, average/1]).

% TODO lookup exactly how specs are defined
-spec report(MetricName :: binary(), MetricValue :: float()) -> ok.
report(MetricName, MetricValue) ->
  MetricPid = get_metric_pid(MetricName),
  metric_server:report(MetricPid, MetricValue).

-spec average(MetricName :: binary()) -> float().
average(MetricName) ->
  % TODO make it so if the process doesn't exist we return undefined
  % MetricPid = Supervisor.get_pid(MetricName),
  MetricPid = get_metric_pid(MetricName),
  metric_server:average(MetricPid).

% Private
get_metric_pid(MetricName) ->
  case metric_sup:start_child(MetricName) of
    {ok, Pid} ->
      Pid
    {already_present, Pid} ->
      Pid
    Term ->
      Term
  end