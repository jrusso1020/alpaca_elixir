defmodule Alpaca.Position do
  @moduledoc """
  A resource that allows us to perform operations on an Position

  An position has the following methods we can call on it
  ```
  get/1
  list/1
  delete_all/0
  delete/1
  ```

  The `get/1` method allows us to get a singular position by calling `Alpaca.Position.get(symbol)`.
  Where `symbol` is the symbol of the position to get.

  The `list/1` method allows us to list all positions by calling `Alpaca.Position.list()`.

  The `delete_all/0` method allows us to close all open positions by calling `Alpaca.Position.delete_all()`.

  The `delete/1` method allows us to close a specific position by calling `Alpaca.Position.delete(symbol)`.
  Where `symbol` is the symbol of the position we want to close.
  """
  use Alpaca.Resource, endpoint: "positions", exclude: [:create, :edit]
end
