defmodule Alpaca.TradeTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Last.Trade

  describe "get/1" do
    test "gets the last trade successfully" do
      use_cassette "last_trade/get_success" do
        assert {:ok, %{status: "success", symbol: "AAPL", last: _last}} = Trade.get("AAPL")
      end
    end

    test "gets the last trade unsuccessfully" do
      use_cassette "last_trade/get_failure" do
        assert {:error, %{status: 404, body: %{code: 40_410_000, message: "resource not found"}}} =
                 Trade.get("FFFFF")
      end
    end
  end
end
