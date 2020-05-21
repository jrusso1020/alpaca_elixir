defmodule Alpaca.Account do
  @moduledoc """
  A resource that allows us to query an Account from Alpaca
  """

  use TypedStruct

  alias Alpaca.Client

  @typedoc "An Account"
  typedstruct enforce: true do
    field(:id, String.t())
    field(:account_number, String.t())
    field(:status, String.t())
    field(:currency, String.t())
    field(:cash, String.t())
    field(:portfolio_value, String.t())
    field(:pattern_day_trader, boolean())
    field(:trade_suspended_by_user, boolean())
    field(:transfers_blocked, boolean())
    field(:account_blocked, boolean())
    field(:created_at, String.t())
    field(:shorting_enabled, boolean())
    field(:long_market_value, String.t())
    field(:equity, String.t())
    field(:last_equity, String.t())
    field(:multiplier, String.t())
    field(:buying_power, String.t())
    field(:initial_margin, String.t())
    field(:maintenance_margin, String.t())
    field(:sma, String.t())
    field(:daytrade_count, String.t())
    field(:last_maintenance_margin, String.t())
    field(:daytrading_buying_power, String.t())
    field(:regt_buying_power, String.t())
  end

  @doc """
  Retrieve your Alpaca trading account info

  ## Example
    iex> {:ok, %Account{} = account} = Account.get()

  Allows us to retrieve our own account information as a result tuple {:ok, %Account{}}
  if successful. If not success we will get back a result tuple {:error, {status: http_status_code, body: http_response_body}}
  """
  @spec get() :: {:ok, %__MODULE__{}} | {:error, Map.t()}
  def get() do
    case Client.get("/v2/account") do
      {:ok, account} ->
        {:ok, struct(__MODULE__, account)}

      {:error, error} ->
        {:error, error}
    end
  end
end
