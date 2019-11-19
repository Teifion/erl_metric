-module (metric_api).

-export([report/2, average/1]).

-import (metric_server, [report/2, report/3, average/1]).
-import (metric_sup, [start_link/1]).

% -spec report(MetricName :: binary(), MetricValue :: float()).
report(MetricName, MetricValue) ->
  MetricPid = metric_sup:start_link(metric_server, [{name, MetricName}]),
  metric_server:report(MetricPid, MetricValue).

% -spec report(MetricName :: binary(), MetricValue :: float(), Timestamp :: integer()).
report(MetricName, MetricValue, Timestamp) ->
  MetricPid = metric_sup:start_link(metric_server, [{name, MetricName}]),
  metric_server:report(MetricPid, MetricValue, Timestamp).

% -spec average(MetricName :: binary()) -> float().
average(MetricName) ->
  % TODO make it so if the process doesn't exist we return undefined
  MetricPid = Supervisor.get_pid(MetricName),
  metric_server:average(MetricPid).
