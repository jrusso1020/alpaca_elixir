defmodule Alpaca.Account.Portfolio.History do
  @moduledoc """
  A resource that allows us to perform operations on an Account portfolio history

  An account portfolio history has the following methods we can call on it
  ```
  list/1
  ```

  The `list/1` method allows us to list all account portolio history by calling
  `Alpaca.Account.Portfolio.History.list(params)`. Where the params is a map of query params
  defined by the Alpaca API documentation.
  """
  use Alpaca.Resource,
    endpoint: "account/portfolio/history",
    exclude: [:create, :edit, :delete, :delete_all, :get]
end
