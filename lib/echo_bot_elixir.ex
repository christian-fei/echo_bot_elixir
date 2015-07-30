defmodule State do
  defstruct latest_update_id: nil, telegram_example_chat_id: Application.get_env(:echo_bot_elixir, :telegram_example_chat_id)
end

defmodule EchoBotElixir do
  def start_link do
    {:ok, pid} = Task.start_link(fn -> loop(%State{}) end)
    Process.register(pid, :bot)
  end

  defp loop(state) do
    receive do
      :poll ->
        poll_id = state.latest_update_id
        get_update_response = TelegramApi.getUpdates poll_id
        parsed_get_update_response = parse_get_update get_update_response
        telegramMessageUpdates = TelegramMessageUpdatesBuilder.buildWith parsed_get_update_response
        latest_update_id = telegramMessageUpdates.latest_update_id
        new_state = update_state(latest_update_id, state)

        case latest_update_id do
          nil ->
            :ok
          _ ->
            send_messages telegramMessageUpdates.messages
        end

        loop(new_state)
    after
      1_000 ->
        send(self(), :poll)
        loop(state)
    end
  end


  defp send_messages [] do
    :ok
  end


  defp send_messages [head | tail] do
    TelegramApi.sendMessage head["chat_id"], "suka hard duro"
    send_messages tail
  end


  defp update_state(nil, state), do: state

  defp update_state(update_id, state), do: %State{latest_update_id: update_id + 1}



  defp parse_get_update({:error, reason}), do: %GetUpdatesResponse{}

  defp parse_get_update({:ok, update}) do
    Poison.decode! update, as: GetUpdatesResponse
  end
end