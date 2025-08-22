defmodule AgentApp do
  @moduledoc false
  
  use Nursery,
    app_name:        :agent_app,
    strategy:        :one_for_one,
    supervisor_name: AgentApp.Sup,
    children: [
      [spec: Supervisor.child_spec({Agent, fn -> 0 end}, id: :agent_a), envs: [:all]],
      [spec: Supervisor.child_spec({Agent, fn -> 1 end}, id: :agent_b), envs: [:prod]],
      [spec: Supervisor.child_spec({Agent, fn -> 2 end}, id: :agent_c), envs: :all],
      [spec: Supervisor.child_spec({Agent, fn -> 3 end}, id: :agent_d), envs: [:test]],
      [spec: Supervisor.child_spec({Agent, fn -> 4 end}, id: :agent_e), envs: [:test]]
    ]
end
