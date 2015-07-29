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
        update = TelegramApi.getUpdates poll_id
        print_result update
        parsed_update = parse update
        latest_update_id = get_latest_update_id parsed_update.result
        IO.puts "latest_update_id"
        IO.inspect latest_update_id
        new_state = update_state(latest_update_id, state)

        case latest_update_id do
          nil ->
            :ok
          _ ->
            {:ok, telegram_example_chat_id} = Map.fetch state, :telegram_example_chat_id
            IO.puts telegram_example_chat_id
            TelegramApi.sendMessage telegram_example_chat_id, "suka hard duro"
        end

        loop(new_state)
    after
      1_000 ->
        send(self(), :poll)
        loop(state)
    end
  end

  defp update_state(nil, state), do: state

  defp update_state(update_id, state), do: %State{latest_update_id: update_id + 1}

  defp parse({:error, reason}), do: %GetUpdatesResponse{}

  defp parse({:ok, update}) do
    Poison.decode! update, as: GetUpdatesResponse
  end


  defp print_result({:error, reason}), do: IO.puts(reason)

  defp print_result({:ok, update}) do
    parsed_update = parse {:ok, update}
    IO.inspect(parsed_update.result)
  end


  defp get_latest_update_id([]), do: nil

  defp get_latest_update_id(results) do
    [h|_] = Enum.reverse results
    h["update_id"]
  end

end