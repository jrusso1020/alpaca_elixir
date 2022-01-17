defmodule Alpaca.WatchlistTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Watchlist

  describe "create/1" do
    test "creates a new Watchlist successfully" do
      use_cassette "watchlist/create_success" do
        params = %{
          name: "Watchlist to make money",
          symbols: ["AAPL", "GOOG", "TSLA"]
        }

        assert {:ok, _watchlist} = Watchlist.create(params)
      end
    end

    test "does not create a new Watchlist successfully" do
      use_cassette "watchlist/create_failure" do
        params = %{
          name:
            "REALLLLLYYYYYYYYY LONG WATCHLIST NAME LONGER THAN 64 characters so this should error out",
          symbols: ["AAPL", "GOOG", "TSLA"]
        }

        message = "name must be no more than 64 characters"

        assert {:error, %{status: 422, body: %{code: 40_010_001, message: ^message}}} =
                 Watchlist.create(params)
      end
    end
  end

  describe "get/1" do
    test "gets a Watchlist successfully" do
      use_cassette "watchlist/get_success" do
        id = "593e74b2-9eb7-4278-95ba-400ea3dae0d5"
        assert {:ok, %{id: ^id}} = Watchlist.get(id)
      end
    end

    test "getting a watchlist that doesn't exist with a bad id" do
      use_cassette "watchlist/get_not_found_bad_id" do
        id = "fake_id"

        assert {:error,
                %{status: 422, body: %{code: 40_010_001, message: "watchlist is required"}}} =
                 Watchlist.get(id)
      end
    end

    test "getting a watchlist that doesn't exist with a welformed id" do
      use_cassette "watchlist/get_not_found_welformed_id" do
        id = "b0b6dd9d-8b9b-48a9-ba46-b9d54906e415"
        message = "watchlist not found: #{id}"

        assert {:error, %{status: 404, body: %{code: 40_410_000, message: ^message}}} =
                 Watchlist.get(id)
      end
    end
  end

  describe "list/0" do
    test "list watchlists successfully" do
      use_cassette "watchlist/list_success" do
        assert {:ok, watchlists} = Watchlist.list()

        assert length(watchlists) == 2
      end
    end
  end

  describe "update/2" do
    test "update watchlist successfully" do
      use_cassette "watchlist/update_success" do
        id = "593e74b2-9eb7-4278-95ba-400ea3dae0d5"
        name = "New Name of watchlist"
        params = %{name: name}

        assert {:ok, %{id: ^id, name: ^name}} = Watchlist.update(id, params)
      end
    end
  end

  describe "add_asset/2" do
    test "adds an asset to a watchlist successfully" do
      use_cassette "watchlist/add_asset_success" do
        id = "593e74b2-9eb7-4278-95ba-400ea3dae0d5"
        symbol = "F"
        params = %{symbol: symbol}

        assert {:ok, %{id: ^id}} = Watchlist.add_asset(id, params)
      end
    end
  end

  describe "remove_asset/2" do
    test "adds an asset to a watchlist successfully" do
      use_cassette "watchlist/remove_asset_success" do
        id = "593e74b2-9eb7-4278-95ba-400ea3dae0d5"
        symbol = "F"

        assert {:ok, %{id: ^id}} = Watchlist.remove_asset(id, symbol)
      end
    end
  end

  describe "delete/1" do
    test "delete a watchlist successfully" do
      use_cassette "watchlist/delete_success" do
        id = "593e74b2-9eb7-4278-95ba-400ea3dae0d5"

        assert :ok = Watchlist.delete(id)
      end
    end
  end
end
