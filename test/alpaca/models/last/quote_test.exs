defmodule Alpaca.QuoteTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Last.Quote

  describe "get/1" do
    test "gets the last quote successfully" do
      use_cassette "last_quote/get_success" do
        assert {:ok, %{status: "success", symbol: "AAPL", last: _last}} = Quote.get("AAPL")
      end
    end

    test "gets the last quote unsuccessfully" do
      use_cassette "last_quote/get_failure" do
        assert {:error, %{status: 404, body: %{code: 40_410_000, message: "resource not found"}}} =
                 Quote.get("FFFFF")
      end
    end
  end
end
