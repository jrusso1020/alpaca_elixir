defmodule Alpaca.OrderTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Order

  describe "list/1" do
    test "gets the list of orders successfully" do
      use_cassette "order/list_success" do
        params = %{status: "all"}

        assert {:ok, [order]} = Order.list(params)
        assert not is_nil(order.id)
      end
    end
  end

  describe "get/1" do
    test "gets a specific order successfully" do
      use_cassette "order/get_success" do
        id = "ebfc1c74-fd4a-46e1-b4e7-7f6f8ab1ef7a"

        assert {:ok, %{id: ^id}} = Order.get(id)
      end
    end

    test "getting an order that doesn't exist with a bad id" do
      use_cassette "order/get_not_found_bad_id" do
        id = "fake_id"

        assert {:error, %{status: 422, body: %{code: 40_010_001, message: "order_id is missing"}}} =
                 Order.get(id)
      end
    end

    test "getting an order that doesn't exist with a welformed id" do
      use_cassette "order/get_not_found_welformed_id" do
        id = "b0b6dd9d-8b9b-48a9-ba46-b9d54906e415"
        message = "order not found for #{id}"

        assert {:error, %{status: 404, body: %{code: 40_410_000, message: ^message}}} =
                 Order.get(id)
      end
    end
  end

  describe "create/1" do
    test "creates a new order successfully" do
      use_cassette "order/create_success" do
        params = %{
          symbol: "TSLA",
          qty: 1,
          side: "buy",
          type: "market",
          time_in_force: "day"
        }

        assert {:ok, order} = Order.create(params)
        assert not is_nil(order.id)
      end
    end

    test "trying to create a new order with bad params" do
      use_cassette "order/create_422" do
        params = %{
          symbol: "FACEBOOK",
          qty: 1,
          side: "buy",
          type: "market",
          time_in_force: "day"
        }

        assert {:error,
                %{
                  status: 422,
                  body: %{code: 40_010_001, message: "could not find asset \"FACEBOOK\""}
                }} = Order.create(params)
      end
    end

    test "trying to create a new order above buying power" do
      use_cassette "order/create_403" do
        params = %{
          symbol: "TSLA",
          qty: 10_000_000,
          side: "buy",
          type: "market",
          time_in_force: "day"
        }

        assert {:error,
                %{status: 403, body: %{code: 40_310_000, message: "insufficient buying power"}}} =
                 Order.create(params)
      end
    end
  end

  describe "get_by_client_orderid/1" do
    test "gets order successfully" do
      use_cassette "order/get_by_client_order_id_success" do
        client_order_id = "e08ad98f-07a4-40a8-9b6e-7186b0b7dd8d"

        assert {:ok, %{client_order_id: ^client_order_id}} =
                 Order.get_by_client_order_id(client_order_id)
      end
    end

    test "gets order unsuccessfully" do
      use_cassette "order/get_by_client_order_id_failure" do
        not_client_order_id = "b0b6dd9d-8b9b-48a9-ba46-b9d54906e415"
        message = "order not found for #{not_client_order_id}"

        assert {:error, %{status: 404, body: %{code: 40_410_000, message: ^message}}} =
                 Order.get_by_client_order_id(not_client_order_id)
      end
    end
  end

  describe "edit/1" do
    test "edits an order unsuccessfully" do
      use_cassette "order/edit_failure" do
        id = "ebfc1c74-fd4a-46e1-b4e7-7f6f8ab1ef7a"

        assert {:error,
                %{
                  status: 422,
                  body: %{
                    code: 40_010_001,
                    message: "unable to replace order, order isn't sent to exchange yet"
                  }
                }} = Order.edit(id, %{qty: 3})
      end
    end
  end

  describe "delete_all/0" do
    test "deletes all orders successfully" do
      use_cassette "order/delete_all_success" do
        assert {:ok, response} = Order.delete_all()

        Enum.map(response, fn item ->
          assert item.status == 200
          assert not is_nil(item.id)
          assert not is_nil(item.resource)
        end)
      end
    end
  end

  describe "delete/1" do
    test "deletes an order successfully" do
      use_cassette "order/delete_success" do
        id = "d2ddd83c-63f5-42d4-801b-58e1be01327b"
        assert :ok = Order.delete(id)
      end
    end

    test "can not find an order to delete" do
      use_cassette "order/delete_not_found" do
        bad_id = "b0b6dd9d-8b9b-48a9-ba46-b9d54906e415"
        message = "order not found for #{bad_id}"

        assert {:error, %{status: 404, body: %{code: 40_410_000, message: ^message}}} =
                 Order.delete(bad_id)
      end
    end
  end
end
