defmodule TelegramApi do

  @token Application.get_env(:echo_bot_elixir, :telegram_api_token)

  def get_updates offset do
    url = "https://api.telegram.org/bot#{@token}/getUpdates?offset=#{offset}"
    function = fn -> HTTPoison.get url end
    do_apply function
  end

  def send_message chat_id, text do
    url = "https://api.telegram.org/bot#{@token}/sendMessage"
    body = {:form, [chat_id: chat_id, text: text]}
    headers = %{"Content-type": "application/x-www-form-urlencoded"}
    function = fn -> HTTPoison.post url, body, headers end
    do_apply function
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
