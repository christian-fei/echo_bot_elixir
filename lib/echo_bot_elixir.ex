defmodule GetUpdatesResponse do
  defstruct ok: "false", result: []
end

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
        update = do_poll poll_id
        print_result update
        parsed_update = parse update
        latest_update_id = get_latest_update_id parsed_update.result
        IO.puts "latest_update_id"
        IO.inspect latest_update_id
        new_state = update_state(latest_update_id, state)
        loop(new_state)
    after
      1_000 ->
        send(self(), :poll)
        loop(state)
    end
  end

  defp update_state(nil, state), do: state

  defp update_state(update_id, state), do: %State{latest_update_id: update_id + 1}

  defp do_poll poll_id do
    token = Application.get_env(:echo_bot_elixir, :telegram_api_token)
    url = "https://api.telegram.org/bot#{token}/getUpdates?offset=#{poll_id}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found :("}
      {:error, %HTTPoison.Error{reason: _reason}} ->
        {:error, "nasty exception here call the elixir police"}
    end
  end


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