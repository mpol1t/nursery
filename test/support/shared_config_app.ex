defmodule SharedConfigCounter do
  @moduledoc false

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def increment do
    Agent.update(__MODULE__, &(&1 + 1))
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end
end

defmodule SharedConfigApp do
  @moduledoc false

  use Nursery,
    app_name: :shared_config_app,
    strategy: :one_for_one,
    supervisor_name: SharedConfigApp.Sup,
    shared_config: &__MODULE__.shared_config/0,
    children: [
      [spec: &__MODULE__.worker_spec(:alpha, &1), envs: :all],
      [spec: &__MODULE__.worker_spec(:beta, &1), envs: :all],
      [spec: &__MODULE__.worker_spec(:gamma, &1), envs: [:prod]]
    ]

  def shared_config do
    SharedConfigCounter.increment()
    %{token: "shared-token"}
  end

  def worker_spec(id, shared) do
    Supervisor.child_spec({Agent, fn -> shared end}, id: id)
  end
end
