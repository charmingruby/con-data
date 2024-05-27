defmodule Jobbex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    job_runner_config = [
      name: Jobbex.JobRunner,
      strategy: :one_for_one,
      max_seconds: 30_000
    ]

    children = [
      {Registry, keys: :unique, name: Jobbex.JobRegistry},
      {DynamicSupervisor, job_runner_config}
    ]

    opts = [strategy: :one_for_one, name: Jobbex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
