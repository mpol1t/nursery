defmodule NurseryMacroTest do
  use ExUnit.Case, async: false

  defp start_app!(mod) do
    start_supervised!(%{
      id:    {:app_under_test, mod},
      start: {mod, :start, [:normal, []]}
    })
  end

  test "in :test env only :all children run (2 agents)" do
    Application.put_env(:agent_app, :environment, :test)

    sup = start_app!(AgentApp)
    assert is_pid(sup)

    kids = Supervisor.which_children(AgentApp.Sup)
    assert length(kids) == 4

    counts = Supervisor.count_children(AgentApp.Sup)
    assert counts.active == 4
    assert counts.specs  == 4
  end

  test "in :prod env all envs [:prod | :all] run" do
    Application.put_env(:agent_app, :environment, :prod)

    _sup = start_app!(AgentApp)

    kids = Supervisor.which_children(AgentApp.Sup)
    assert length(kids) == 3
    assert Supervisor.count_children(AgentApp.Sup).active == 3
  end
end
