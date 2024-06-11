defmodule Alpaca.Watchlist do
  @moduledoc """
  A resource that allows us to perform operations on an Watchlist

  A watchlist has the following methods we can call on it
  ```
  get/1
  list/0
  create/1
  update/2
  add_asset/2
  remove_asset/2
  delete/1
  ```

  The `get/1` method allows us to get a singular watchlist by calling `Alpaca.Watchlist.get(id)`.
  Where `id` is the id of the watchlist to get.

  The `list/0` method allows us to list all watchlists by calling `Alpaca.Watchlist.list()`.

  The `create/1` method allows us to create a new watchlist by calling `Alpaca.Watchlist.create(params)`.
  Where `params` is the Map of parameters to create the watchlist

  The `update/2` method allows us to update a specific watchlist by calling `Alpaca.Watchlist.update(id, params)`.
  Where `id` is the id of the watchlist and `params` are the parameters of the watchlist we want to
  update defined by the Alpaca API documentation.

  The `add_asset/2` method allows us to add an asset to a specific watchlist by calling `Alpaca.Watchlist.add_asset(id, params)`.
  Where `id` is the id of the watchlist and `params` are the parameters of the asset to add. At this time just
  a key `symbol` is needed.

  The `remove_asset/2` method allows us to remove an asset from a specific watchlist by calling `Alpaca.Watchlist.remove_asset(id, symbol)`.
  Where `id` is the id of the watchlist and symbol is the symbol to remove

  The `delete/1` method allows us to delete a specific watchlist by calling `Alpaca.Watchlist.delete(id)`.
  Where `id` is the id of the order we want to delete.
  """
  use Alpaca.Resource, endpoint: "watchlists", exclude: [:edit, :delete_all]

  alias Alpaca.Client

  @doc """
  Adds an asset to a watchlist

  ### Example
  ```
    iex> {:ok, %{} = watchlist} = Alpaca.Watchlist.add_asset(id, %{symbol: symbol})
  ```

  Allows us to add an asset to a watchlist and get back a a result tuple `{:ok, %{}}`
  if successful. If not success we will get back a result tuple `{:error, {status: http_status_code, body: http_response_body}}`
  """
  def add_asset(id, params \\ %{}) do
    Client.post("/v1/watchlists/#{id}", params)
  end

  @doc """
  Remove an asset from a watchlist

  ### Example
  ```
    iex> {:ok, %{} = watchlist} = Alpaca.Watchlist.remove_asset(id, symbol)
  ```

  Allows us to remove an asset from a watchlist and get back a a result tuple `{:ok, %{}}`
  if successful. If not success we will get back a result tuple `{:error, {status: http_status_code, body: http_response_body}}`
  """
  def remove_asset(id, symbol) do
    Client.delete("/v1/watchlists/#{id}/#{symbol}")
  end
end
