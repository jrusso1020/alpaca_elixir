defmodule Alpaca.Calendar do
  @moduledoc """
  A resource that allows us to perform operations on an Calendar

  An calendar has the following methods we can call on it
  ```
  list/1
  ```

  The `list/1` method allows us to serve the full list of market days from 1970 to 2029.
  It can also be queried by specifying a start and/or end time to narrow down the results.
  In addition to the dates, the response also contains the specific open and close times
  for the market days, taking into account early closures.

  You can pass optional `start` and/or `end` dates as params to the function to get specific
  time ranges like so `Alpaca.Calendar.list(%{start: ~D[2020-02-10], end: ~D[2020-03-01]})`
  """
  use Alpaca.Resource,
    endpoint: "calendar",
    exclude: [:create, :edit, :delete, :delete_all, :get, :update]
end
