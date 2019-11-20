-import (metric_api, [average/1, report/2, report/3]).

basic_test () ->
  ExpiredTime = system_time() - 61 * 1000,
  
  % Test average being calculated based off 3 simple values
  _ = report(metric1, 10),
  _ = report(metric1, 11),
  _ = report(metric1, 12),
  11 = average(metric1),

  % Now test if we add older ones if they are counted
  _ = report(metric2, 1000, ExpiredTime),
  _ = report(metric2, 1000, ExpiredTime),
  _ = report(metric2, 1000, ExpiredTime),
  _ = report(metric2, 10),
  10 = average(metric2),
  
  % Now test adding a lot of values to ensure the system doesn't fall over
  Values = lists:duplicate(1000, [1, 2, 3, 4, 5])
  InsertMetric = (fun (V) -> report(metric3, V) end)

  % Insert
  lists:map(InsertMetric, Values)

  % Check we can get the average
  _ = average(metric3),

  ok.
