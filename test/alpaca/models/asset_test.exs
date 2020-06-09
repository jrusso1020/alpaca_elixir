defmodule Alpaca.AssetTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Asset

  describe "list/1" do
    test "gets the list of assets successfully" do
      use_cassette "asset/list_success" do
        assert {:ok, assets} = Asset.list()
        assert length(assets) == 9729
      end
    end
  end

  describe "get/1" do
    test "gets the asset successfully by symbol" do
      use_cassette "asset/get_success_by_symbol" do
        assert {:ok, %{symbol: "AAPL"}} = Asset.get("AAPL")
      end
    end

    test "gets the asset successfully by id" do
      use_cassette "asset/get_success_by_id" do
        assert {:ok, %{id: "c33af055-182d-4391-b180-7c3f6ad92743", symbol: "KTP"}} =
                 Asset.get("c33af055-182d-4391-b180-7c3f6ad92743")
      end
    end

    test "cannot find the asset" do
      use_cassette "asset/get_not_found" do
        symbol = "FFFFF"
        message = "asset not found for FFFFF"

        assert {:error, %{status: 404, body: %{code: 40_410_000, message: ^message}}} =
                 Asset.get(symbol)
      end
    end
  end
end
