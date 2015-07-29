defmodule TelegramMessageUpdatesBuilder do
  def buildWith getUpdatesResponse do
    case getUpdatesResponse do
      %GetUpdatesResponse{ok: "false", result: _} -> nil
    end
  end
end