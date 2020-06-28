defmodule Alpaca.Last.Trade do
  @moduledoc """
  A resource that allows us to query for the last trade of a symbol

  A last trade has the following methods we can call on it
  ```
  get/1
  ```

  The `get/1` method allows us to get a singular last trade for a given symbol by calling
  `Alpaca.Last.Trade.get(symbol)`. Where `symbol` is the
  stock symbol you want to retrieve last trade information for.
  """
  alias Alpaca.Client

  use Alpaca.Resource,
    endpoint: "last/stocks",
    exclude: [:list, :create, :edit, :delete, :delete_all, :update],
    opts: [version: "v1", api_host: Client.data_api_host()]
end
