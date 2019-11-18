-module(metric_app).
-behaviour(application).

-export([report/2, average/1]).

% Store stuff for 60 seconds as per the requirements
-define(SCAN_PERIOD, 60 * 1000).

-spec report(MetricName :: binary(), MetricValue :: float()).
report(metric_name, metric_value) ->
  pass    

-spec average(MetricName :: binary()) -> float().
average(metric_name, metric_value) ->
  pass
