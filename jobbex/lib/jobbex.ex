defmodule Jobbex do
  @moduledoc false
  alias Jobbex.Jobs.Job
  alias Jobbex.JobRunner
  alias Jobbex.Jobs.JobSupervisor

  def start_job(args) do
    if Enum.count(Job.running_imports()) >= 5 do
      {:error, :import_quota_reached}
    else
      DynamicSupervisor.start_child(
        JobRunner,
        {JobSupervisor, args}
      )
    end
  end
end
