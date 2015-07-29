defmodule TelegramGetUpdatesToModelTest do
  use ExUnit.Case

  test "returns nil if cannot convert GetUpdatesResponse" do
    getUpdatesResponse = %GetUpdatesResponse{}

    result = TelegramMessageUpdatesBuilder.buildWith getUpdatesResponse

    assert result == nil
  end
end
