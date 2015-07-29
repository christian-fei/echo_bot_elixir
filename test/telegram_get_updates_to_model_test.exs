defmodule TelegramGetUpdatesToModelTest do
  use ExUnit.Case

  test "returns nil if cannot convert GetUpdatesResponse" do
    getUpdatesResponse = %GetUpdatesResponse{}

    result = TelegramMessageUpdatesBuilder.buildWith getUpdatesResponse

    assert result == nil
  end

  test "returns GetUpdatesResponse with empty messages if can convert GetUpdatesResponse" do
    getUpdatesResponse = %GetUpdatesResponse{ok: "true", result: []}

    result = TelegramMessageUpdatesBuilder.buildWith getUpdatesResponse
    expected = %TelegramMessageUpdates{latest_update_id: nil, messages: []}

    assert result != nil
    assert result == expected
  end
end