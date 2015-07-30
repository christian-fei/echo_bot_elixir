defmodule State do
  defstruct latest_update_id: nil
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
        telegramMessageUpdates = TelegramMessageUpdatesMapper.buildWith parsed_get_update_response
        send_messages telegramMessageUpdates.messages
        latest_update_id = telegramMessageUpdates.latest_update_id
        loop update_state(latest_update_id, state)
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