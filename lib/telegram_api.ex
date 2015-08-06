defmodule TelegramApi do

  @token Application.get_env(:echo_bot_elixir, :telegram_api_token)

  def get_updates offset do
    url = "https://api.telegram.org/bot#{@token}/getUpdates?offset=#{offset}"
    do_apply fn -> HTTPoison.get(url) end
  end

  def send_message chat_id, text do
    url = "https://api.telegram.org/bot#{@token}/sendMessage"
    do_apply fn -> HTTPoison.post(url, {:form, [chat_id: chat_id, text: text]}, %{"Content-type": "application/x-www-form-urlencoded"}) end
  end

  defp do_apply fun do
    case fun.() do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

end
