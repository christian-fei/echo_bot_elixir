defmodule TelegramApi do

  def getUpdates poll_id do
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

end