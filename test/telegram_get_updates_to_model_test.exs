defmodule TelegramGetUpdatesToModelTest do
  use ExUnit.Case

  test "builds TelegramMessageUpdates from response" do
    getUpdatesResponse = %{ok: true, result: [%{"message" => %{"chat" => %{"first_name" => "cf","id" => 27922851,"username" => "cfcfcfcf"},"date" => 1438213716,"from" => %{"first_name" => "cf","id" => 27922851,"username" => "cfcfcfcf"},"message_id" => 35,"text" => "/echo test"},"update_id" => 968217487}]}

    result = TelegramMessageUpdatesMapper.buildWith getUpdatesResponse
    expected = %TelegramMessageUpdates{latest_update_id: 968217487, messages: [%{
      "text" => "/echo test",
      "chat_id" => 27922851,
      "update_id" => 968217487
    }]}

    assert result == expected
  end
end