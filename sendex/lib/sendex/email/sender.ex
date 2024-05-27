defmodule Sendex.Email.Sender do
  require Logger

  @delay_in_seconds 1

  def send_email("dummy_3@email.com"),
    do: :error

  def send_email(email) do
    delay = @delay_in_seconds * 1000
    Process.sleep(delay)

    Logger.info("Email to '#{email}' sent")

    {:ok, "email_sent", email}
  end

  def notify_all(emails) do
    Sendex.EmailTaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &send_email/1)
    |> IO.inspect()
    |> Enum.to_list()
  end
end
