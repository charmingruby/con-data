defmodule Jobbex do
  @moduledoc false
  alias Jobbex.JobRunner
  alias Jobbex.Jobs.JobSupervisor

  def start_job(args),
    do:
      DynamicSupervisor.start_child(
        JobRunner,
        {JobSupervisor, args}
      )
end
