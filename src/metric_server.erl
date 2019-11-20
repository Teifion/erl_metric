-module(metric_server).
-behaviour(gen_server).

-export ([average/1, report/2, handle_call/3, handle_cast/2, init/1, start_link/1]).

-ifdef(TEST).
-compile([export_all]).
-endif.

% Store stuff for 60 seconds as per the requirements
-define(SCAN_PERIOD, 60 * 1000).

init(_) ->
  {ok, []}.

start_link(MetricName) ->
  gen_server:start_link({local, MetricName}, ?MODULE, [], []).

report (Pid, Value) ->
  Timestamp = os:system_time(),
  gen_server:cast(Pid, {report, {Value, Timestamp}}).

average (Pid) ->
  gen_server:call(Pid, {average, nil}).

get_timestamp() ->
  os:timestamp().

% Callbacks
handle_call({average, _}, _From, State) ->
  {reply, get_average(State), State}.

handle_cast({report, Value, Timestamp}, State) ->
  io:write("CAST"),
  {noreply, [{Value, Timestamp} | State]}.

get_average(ValueList) ->
  % LowerBound defaults to 60 seconds ago
  LowerBound = os:system_time() - ?SCAN_PERIOD,

  TimestampFilter = fun ({_, Timestamp}) -> Timestamp > LowerBound end,
  SumFold = (fun ({V, _}, Acc) -> V + Acc end),

  FilteredState = lists:filter(TimestampFilter, ValueList),
  SumResult = lists:foldl(SumFold, 0, FilteredState),
  CountResult = length(FilteredState),
  SumResult/CountResult.
