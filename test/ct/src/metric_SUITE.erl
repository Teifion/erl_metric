-module (metric_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([all/0]).
-export([test1/1]).

all() -> [test1].

test1(_Config) ->
  metric_sup:start_link(),

  metric_api:report(metric1, 10),
  metric_api:report(metric1, 20),
  metric_api:report(metric1, 90),
  metric_api:report(metric2, 1000),

  metric_api:average(metric1),

  ok.
