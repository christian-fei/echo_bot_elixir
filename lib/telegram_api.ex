defmodule TelegramApi do

  def get_updates offset do
    token = Application.get_env(:echo_bot_elixir, :telegram_api_token)
    url = "https://api.telegram.org/bot#{token}/getUpdates?offset=#{offset}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def send_message chat_id, text do
    token = Application.get_env(:echo_bot_elixir, :telegram_api_token)
    url = "https://api.telegram.org/bot#{token}/sendMessage"
    case HTTPoison.post(url, {:form, [chat_id: chat_id, text: text]}, %{"Content-type": "application/x-www-form-urlencoded"}) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

end
