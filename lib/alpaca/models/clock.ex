defmodule Alpaca.Clock do
  @moduledoc """
  A resource that allows us to perform operations on an clock

  An clock has the following methods we can call on it
  ```
  get/0
  ```

  The `get/0` method allows us to serve the current market timestamp, whether or not the market
  is currently open, as well as the times of the next market open and close.

  You can call it like so `Alpaca.Clock.get()`
  """

  alias Alpaca.Client

  @doc """
  Retrieve the clock information now

  ## Example
    iex> {:ok, %{timestamp: timestamp, is_open: is_open, next_open: next_open, next_close: next_close} = clock} = Alpaca.Clock.get()

  Allows us to serve the current market timestamp, whether or not the market
  is currently open, as well as the times of the next market open and close.
  """
  @spec get() :: {:ok, map()} | {:error, map()}
  def get() do
    Client.get("/v2/clock")
  end
end
