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

  @spec get(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def get(symbol, params \\ %{}) do
    Client.get("/v2/stocks/#{symbol}/trades/latest", params, api_host: Client.data_api_host())
  end
end
