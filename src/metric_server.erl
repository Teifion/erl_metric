-module(name_server).
-behaviour(gen_server).

% We store the name of the metric against the process PID in ETS

% Store stuff for 60 seconds as per the requirements
-define(SCAN_PERIOD, 60 * 1000).

init([]) -> {ok, []}.

report (Pid, Value) ->
  report(Pid, Value, system_time())

report (Pid, Value, Timestamp) ->
  gen_server:cast(Pid, {report, {Value, Timestamp}}).

average () ->
  gen_server:call(Pid, {average, nil}).


% Callbacks
handle_call ({average, _}, State) ->
  % LowerBound defaults to 60 seconds ago
  LowerBound = system_time() - SCAN_PERIOD.

  FilteredState = lists:filter(fun ({_, Timestamp}) -> Timestamp > LowerBound end, State).
  SumResult = lists:foldl(fun (V, Acc) -> V + Acc end, 0, FilteredState).
  CountResult = length(FilteredState).

  Result = SumResult/CountResult.

  {reply, Result, State}.

handle_cast({report, {Value, Timestamp}}, State) ->
  {noreply, [{Value, Timestamp} | State]}.
