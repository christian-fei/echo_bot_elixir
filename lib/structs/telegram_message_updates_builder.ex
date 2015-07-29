defmodule TelegramMessageUpdatesBuilder do
  def buildWith getUpdatesResponse do
    case getUpdatesResponse do
      %GetUpdatesResponse{ok: "false", result: _} -> nil
      %GetUpdatesResponse{ok: "true", result: result} ->
        %TelegramMessageUpdates{latest_update_id: nil, messages: []}
    end
  end
end