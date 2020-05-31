defmodule Alpaca.Order do
  @moduledoc """
  A resource that allows us to perform operations on an Order

  An order has the following methods we can call on it
  ```
  get/1
  list/1
  create/1
  edit/2
  delete_all/0
  delete/1
  get_by_client_order_id/1
  ```

  The `get/1` method allows us to get a singular order by calling `Alpaca.Order.get(id)`.
  Where `id` is the id of the order to get.

  The `list/1` method allows us to list all orders by calling `Alpaca.Order.list(params)`.
  Where `params` is a Map of optional params you can use to retrieve orders
  defined in the Alpaca API documentation

  The `create/1` method allows us to create a new order by calling `Alpaca.Order.create(params)`.
  Where `params` is the Map of parameters to create the order

  The `edit/2` method allows us to edit a specific order by calling `Alpaca.Order.edit(id, params)`.
  Where `id` is the id of the order and `params` are the parameters of the order we want to
  change defined by the Alpaca API documentation.

  The `delete_all/0` method allows us to delete all open orders by calling `Alpaca.Order.delete_all()`.

  The `delete/1` method allows us to delete a specific order by calling `Alpaca.Order.delete(id)`.
  Where id is the id of the order we want to delete.

  The `get_by_client_order_id/1` method allows us to get a specific order by the client order id by calling
  `Alpaca.Order.get_by_client_order_id(client_order_id)`. Where client_order_id is the client order id on the order.
  """
  use Alpaca.Resource, endpoint: "orders"
  use TypedStruct

  @typedoc "An Order"
  typedstruct do
    field(:id, String.t())
    field(:client_order_id, String.t())
    field(:created_at, String.t())
    field(:updated_at, String.t())
    field(:submitted_at, String.t())
    field(:filled_at, String.t())
    field(:expired_at, String.t())
    field(:canceled_at, String.t())
    field(:failed_at, String.t())
    field(:replaced_at, String.t())
    field(:replaced_by, String.t())
    field(:replaces, String.t())
    field(:asset_id, String.t())
    field(:symbol, String.t())
    field(:asset_class, String.t())
    field(:qty, String.t())
    field(:filled_qty, String.t())
    field(:type, String.t())
    field(:side, String.t())
    field(:time_in_force, String.t())
    field(:limit_price, String.t())
    field(:stop_price, String.t())
    field(:filled_avg_price, String.t())
    field(:status, String.t())
    field(:extended_hours, boolean())
    # TODO: investigate best way for nested objects
    # field(:legs, [Order.t()])
  end

  @doc """
  Retrieve an order by client order id

  ### Example
  ```
    iex> {:ok, %Order{} = order} = Order.get_by_client_order_id(client_order_id)
  ```

  Allows us to retrieve our an order as a result tuple `{:ok, %Alpaca.Order{}}`
  if successful. If not success we will get back a result tuple `{:error, {status: http_status_code, body: http_response_body}}`
  """
  @spec get_by_client_order_id(String.t()) :: {:ok, __MODULE__.t()} | {:error, map()}
  def get_by_client_order_id(client_order_id) do
    case Client.get("/v2/orders:by_client_order_id", %{client_order_id: client_order_id}) do
      {:ok, order} ->
        {:ok, struct(__MODULE__, order)}

      {:error, error} ->
        {:error, error}
    end
  end
end
