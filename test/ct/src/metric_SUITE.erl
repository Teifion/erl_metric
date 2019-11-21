-module (metric_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([all/0]).
-export([test1/1]).

all() -> [test1].

test1(_Config) ->
  application:start(metric_application),

  M1 = metric_api:report(metric1, 10),
  ?assert(M1 == ok),
  M2 = metric_api:report(metric1, 20),
  ?assert(M2 == ok),
  M3 = metric_api:report(metric1, 90),
  ?assert(M3 == ok),
  M4 = metric_api:report(metric2, 1000),
  ?assert(M4 == ok),

  Metric1Result = metric_api:average(metric1),
  ?assert(Metric1Result == 40),

  ok.
