defmodule Sendex.Email.SendServer do
  use GenServer

  alias Sendex.Email.Sender

  require Logger

  def handle_info(:retry, state) do
    {failed, done} =
      Enum.split_with(state.emails, fn item ->
        item.status == "failed" && item.retries < state.max_retries
      end)

    retried =
      Enum.map(failed, fn item ->
        IO.inspect(item)
        Logger.info("Retrying email #{item.email}")

        new_status =
          case Sender.send_email(item.email) do
            :error -> "failed"
            {:ok, "email_sent", _} -> "sent"
          end

        %{email: item.email, status: new_status, retries: item.retries + 1}
      end)

    Process.send_after(self(), :retry, 5000)

    new_state = Map.put(state, :emails, retried ++ done)
    {:noreply, new_state}
  end

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_cast({:send, email}, state) do
    status =
      case Sender.send_email(email) do
        :error -> "failed"
        {:ok, "email_sent", _} -> "sent"
      end

    emails = [%{email: email, status: status, retries: 0}] ++ state.emails
    new_state = Map.put(state, :emails, emails)

    {:noreply, new_state}
  end

  def terminate(reason, _state) do
    Logger.info("Terminating with reason #{reason}")
  end

  def init(args) do
    Logger.info("Received arguments: #{inspect(args)}")

    max_retries = Keyword.get(args, :max_retries, 100)
    state = %{emails: [], max_retries: max_retries}
    Process.send_after(self(), :retry, 5000)

    {:ok, state}
  end
end
