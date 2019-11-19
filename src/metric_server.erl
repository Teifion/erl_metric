-module(metric_server).
-behaviour(gen_server).

-export ([average/1, report/2, report/3]).

% Store stuff for 60 seconds as per the requirements
-define(SCAN_PERIOD, 60 * 1000).

init([]) ->
  {ok, []}.

start_link() ->
  gen_server:start_link(?MODULE, [], []).

report (Pid, Value) ->
  report(Pid, Value, os:system_time()).

report (Pid, Value, Timestamp) ->
  gen_server:cast(Pid, {report, {Value, Timestamp}}).

average (Pid) ->
  gen_server:call(Pid, {average, nil}).


% Callbacks
handle_call ({average, _}, _, State) ->
  % LowerBound defaults to 60 seconds ago
  LowerBound = os:system_time() - ?SCAN_PERIOD,

  TimestampFilter = fun ({_, Timestamp}) -> Timestamp > LowerBound end,
  SumFold = (fun ({V, _}, Acc) -> V + Acc end),

  FilteredState = lists:filter(TimestampFilter, State),
  SumResult = lists:foldl(SumFold, 0, FilteredState),
  CountResult = length(FilteredState),

  Result = SumResult/CountResult,

  {reply, Result, State}.

handle_cast({report, {Value, Timestamp}}, State) ->
  {noreply, [{Value, Timestamp} | State]}.
