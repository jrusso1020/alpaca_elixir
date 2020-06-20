defmodule Alpaca.Bar do
  @moduledoc """
  A resource that allows us to query the Bars data from Alpaca
  The bars API provides time-aggregated price and volume data.
  """

  alias Alpaca.Client

  @doc """
  Retrieves a list of bars for each requested symbol.
  It is guaranteed all bars are in ascending order by time.

  ## Example
    iex> {:ok, bars} = Alpaca.Bar.list("day", %{symbols: "APPL,F,TSLA"})

  Allows us to retrieve bars information as a result tuple {:ok, %{}}
  if successful. If not success we will get back a result tuple {:error, {status: http_status_code, body: http_response_body}}
  """
  @spec list(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def list(timeframe, params \\ %{}) do
    Client.get("/v1/bars/#{timeframe}", params, api_host: Client.data_api_host())
  end
end
