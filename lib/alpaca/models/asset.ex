defmodule Alpaca.Asset do
  @moduledoc """
  A resource that allows us to perform operations on an Asset

  An asset has the following methods we can call on it
  ```
  get/1
  list/1
  ```

  The `get/1` method allows us to get a singular asset by calling `Alpaca.Asset.get(symbol)`
  or `Alpaca.Asset.get(id)`. Where `symbol` is the symbol of the asset to get and `id` is the
  Alpaca internal id of the asset.

  The `list/1` method allows us to list all assets by calling `Alpaca.Asset.list(params)`.
  Where the params are a map, and possible options are defined in the Alpaca documentation.
  """
  use Alpaca.Resource,
    endpoint: "assets",
    exclude: [:create, :edit, :delete, :delete_all, :update]
end
