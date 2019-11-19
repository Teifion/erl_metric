-module(metric_application).
-behaviour(application).
-import (metric_sup, [start_link/0]).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
  metric_sup:start_link().

stop(_) ->
  ok.
