defmodule Alpaca.Account do
  @moduledoc """
  A resource that allows us to query an Account from Alpaca
  """

  alias Alpaca.Client

  @doc """
  Retrieve your Alpaca trading account info

  ## Example
    iex> {:ok, %{} = account} = Alpaca.Account.get()

  Allows us to retrieve our own account information as a result tuple {:ok, %{}}
  if successful. If not success we will get back a result tuple {:error, {status: http_status_code, body: http_response_body}}
  """
  @spec get() :: {:ok, map()} | {:error, map()}
  def get() do
    Client.get("/v2/account")
  end
end
