-module (metric_tests).
-include_lib("eunit/include/eunit.hrl").
-import (metric_server, [get_average/1]).

% integeration_test () ->
%   ExpiredTime = os:system_time() - 61 * 1000,
  
%   % Test average being calculated based off 3 simple values
%   _ = report(metric1, 2),
%   _ = report(metric1, 3),
%   _ = report(metric1, 7),
%   ?assert(4 =:= average(metric1)),

%   % Now test if we add older ones if they are counted
%   _ = report(metric2, 1000, ExpiredTime),
%   _ = report(metric2, 1000, ExpiredTime),
%   _ = report(metric2, 1000, ExpiredTime),
%   _ = report(metric2, 10),
%   ?assert(10 = average(metric2)),

%   % Now test adding a lot of values to ensure the system doesn't fall over
%   Values = lists:duplicate(1000, [1, 2, 3, 4, 5]),
%   InsertMetric = (fun (V) -> report(metric3, V) end),

%   % Insert
%   lists:map(InsertMetric, Values),

%   % Check we can get the average
%   ?assert(average(metric3) =:= 3),

%   ok.

basic_test () ->
  ExpiredTime = os:system_time() - 61 * 1000,
  ValidTime = os:system_time(),

  % Basic test
  ?assert(get_average([{1, ValidTime}]) == 1),
  ?assert(get_average([{3, ValidTime}, {100, ExpiredTime}]) == 3),
  ?assert(get_average([{33, ValidTime}, {1, ExpiredTime}]) == 33),

  ValuesA = lists:duplicate(10, 2),
  ValuesB = lists:map(fun (V) -> {V, ValidTime} end, ValuesA),
  
  ?assert(get_average(ValuesB) == 2),

  ok.
