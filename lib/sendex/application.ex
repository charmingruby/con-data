defmodule Sendex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: Sendex.EmailTaskSupervisor,
        start: {
          Task.Supervisor,
          :start_link,
          [[name: Sendex.EmailTaskSupervisor]]
        }
      }
    ]

    opts = [strategy: :one_for_one, name: Sendex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
