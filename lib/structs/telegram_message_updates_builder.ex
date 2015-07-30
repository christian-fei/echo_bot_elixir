defmodule TelegramMessageUpdatesBuilder do
  def buildWith getUpdatesResponse do
    case getUpdatesResponse do
      %GetUpdatesResponse{ok: "false", result: _} -> nil
      %GetUpdatesResponse{ok: "true", result: []} ->
        %TelegramMessageUpdates{latest_update_id: nil, messages: []}
      %GetUpdatesResponse{ok: "true", result: result} ->
        latest_update_id = get_latest_update_id result
        messages = mapToMessages result
        %TelegramMessageUpdates{latest_update_id: latest_update_id, messages: messages}
    end
  end


  defp mapToMessages [] do
    []
  end

  defp mapToMessages [head | tail] do
    [%{"text" => head["message"]["text"], "update_id" => head["update_id"]} | mapToMessages tail]
  end


  defp get_latest_update_id([]), do: nil

  defp get_latest_update_id(results) do
    [h|_] = Enum.reverse results
    h["update_id"]
  end

end