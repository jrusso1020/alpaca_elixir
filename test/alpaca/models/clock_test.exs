defmodule Alpaca.ClockTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Clock

  describe "get/0" do
    test "gets current clock successfully" do
      use_cassette "clock/get_success" do
        assert {:ok,
                %{
                  timestamp: _timestamp,
                  is_open: false,
                  next_open: _next_open,
                  next_close: _next_close
                }} = Clock.get()
      end
    end
  end
end
