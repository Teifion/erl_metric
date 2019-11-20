-module(metric_application).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
  metric_sup:start_link().

stop(_) ->
  ok.
