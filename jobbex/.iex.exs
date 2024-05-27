alias Jobbex.Jobs.Job

good_job =  fn ->
  Process.sleep(2000)
  {:ok, []}
end

bad_job =  fn ->
  Process.sleep(2000)
  :error
end

doomed_job = fn ->
  Process.sleep(2000)
  raise "Job exception"
end
