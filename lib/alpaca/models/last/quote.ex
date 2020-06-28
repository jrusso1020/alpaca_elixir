defmodule Alpaca.Last.Quote do
  @moduledoc """
  A resource that allows us to query for the last quote details for a symbol

  A last quote has the following methods we can call on it
  ```
  get/1
  ```

  The `get/1` method allows us to get a singular last quote for a given symbol by calling
  `Alpaca.Last.Quote.get(symbol)`. Where `symbol` is the
  stock symbol you want to retrieve last quote information for.
  """
  alias Alpaca.Client

  use Alpaca.Resource,
    endpoint: "last_quote/stocks",
    exclude: [:list, :create, :edit, :delete, :delete_all, :update],
    opts: [version: "v1", api_host: Client.data_api_host()]
end
