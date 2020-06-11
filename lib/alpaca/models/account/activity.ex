defmodule Alpaca.Account.Activity do
  @moduledoc """
  A resource that allows us to perform operations on an Account Activity

  An account activity has the following methods we can call on it
  ```
  get/1
  list/1
  ```

  The `get/1` method allows us to get a singular account activity by calling
  `Alpaca.Account.Activity.get(activity_type)`. Where `activity_type` is the
  type of activity you want to retrieve information for.

  The `list/1` method allows us to list all account activities by calling `Alpaca.Account.Activity.list(params)`.
  Where the params is a map, and in this case takes only one param which is `activity_types`. A comma separated
  string of activities types
  """
  use Alpaca.Resource,
    endpoint: "account/activities",
    exclude: [:create, :edit, :delete, :delete_all, :update]
end
