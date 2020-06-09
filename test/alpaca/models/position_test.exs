defmodule Alpaca.PositionTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Position

  describe "list/0" do
    test "gets the list of positions successfully" do
      use_cassette "position/list_success" do
        assert {:ok, positions} = Position.list()
        assert length(positions) == 3
      end
    end
  end

  describe "get/1" do
    test "gets the position successfully" do
      use_cassette "position/get_success" do
        assert {:ok, %{symbol: "AAPL", qty: "2"}} = Position.get("AAPL")
      end
    end

    test "cannot find the position" do
      use_cassette "position/get_not_found" do
        symbol = "F"
        message = "position does not exist"

        assert {:error, %{status: 404, body: %{code: 40_410_000, message: ^message}}} =
                 Position.get(symbol)
      end
    end
  end

  describe "delete_all/0" do
    test "deletes the position successfully" do
      use_cassette "position/delete_all_success" do
        assert {:ok, response} = Position.delete_all()

        Enum.map(response, fn item ->
          if item.id in ["TSLA", "GOOG"] do
            assert item.status == 200
            assert not is_nil(item.id)
            assert not is_nil(item.resource)
          else
            # AAPL has already been liquidated
            assert item.status == 403
            assert not is_nil(item.id)
            assert not is_nil(item.resource)
          end
        end)
      end
    end
  end

  describe "delete/1" do
    test "deletes the position successfully" do
      use_cassette "position/delete_success" do
        assert {:ok, %{symbol: "AAPL", qty: "2"}} = Position.delete("AAPL")
      end
    end

    test "cannot find the position" do
      use_cassette "position/delete_not_found" do
        symbol = "F"
        message = "position does not exist"

        assert {:error, %{status: 404, body: %{code: 40_410_000, message: ^message}}} =
                 Position.delete(symbol)
      end
    end
  end
end
