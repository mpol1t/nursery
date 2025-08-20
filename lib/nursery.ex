defmodule Nursery do
  @moduledoc """
  The `Nursery` module provides functionality for setting up a supervisor 
  with child processes filtered by environment.

  This module defines a macro `__using__/1` that can be used in an Elixir 
  application to configure a supervisor for child processes. The supervisor's 
  child processes are dynamically filtered based on the application's environment.

  ## Example

      defmodule MyApp do
        use Nursery, 
          app_name: :my_app,
          strategy: :one_for_one,
          children: [
            [module: Foo, config: [a: 1], envs: :all],
            [module: Bar, config: [b: 2], envs: [:prod, :dev]],
            [module: Baz,                 envs: [:test]]
          ]
      end
  """

  @doc """
  Macro used to configure the application and supervisor.

  It accepts options that define the child processes and the supervision strategy.
  The children are filtered based on the application's environment.

  ## Options

    - `:app_name` (atom) - The name of the application, used to fetch configuration.
    - `:children` ([keyword()]) - A list of child process specifications.
    - `:strategy` (atom) - The supervision strategy (e.g., `:one_for_one`, `:rest_for_one`).
    - `:supervisor_name` (atom) - The name of the supervisor module (optional, defaults to `__MODULE__.Supervisor`).
  """
  defmacro __using__(opts) do
    app_name        = opts[:app_name]
    children        = opts[:children]
    strategy        = opts[:strategy]
    supervisor_name = Keyword.get(opts, :supervisor_name, __MODULE__.Supervisor)
    
    quote do
      use Application

      def start(_type, _args) do
        Supervisor.start_link(children(), strategy: unquote(strategy), name: unquote(supervisor_name))
      end

      defp children do
        env = Application.fetch_env!(unquote(app_name), :environment)
        unquote(children)
        |> Nursery.Utils.filter_by_env(env)
      end
    end
  end
end
