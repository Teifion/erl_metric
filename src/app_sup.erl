%% The supervisor for the app as a whole

%% @private
-module(app_sup).
-behaviour(supervisor).

%% API.
-export([start_link/0]).

%% supervisor.
-export([init/1]).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% supervisor.

init([]) ->
  Procs = [],
  {ok, {{one_for_all, 10, 10}, Procs}}.
