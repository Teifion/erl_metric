-module(metric_app).
-behaviour(application).

-export([report/2, average/1]).

start(_Type, _Args) ->
  pass.

-spec report(MetricName :: binary(), MetricValue :: float())
report(MetricName, MetricValue) ->
  % get the PID of the metric_server we want, if it doesn't exist it's created
  % Send said metric server the value
  MetricPid = name_server.get(MetricName).
  MetricPid.report(MetricValue).

-spec average(MetricName :: binary()) -> float()
average(MetricName) ->
  MetricPid = name_server.get(MetricName).
  MetricPid.report(MetricValue).
  % get the PID of the metric_server we want, if it doesn't exist we fail
  % It generates the return value we send back from here
