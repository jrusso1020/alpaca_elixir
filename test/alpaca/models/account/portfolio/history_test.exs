defmodule Alpaca.Account.Portfolio.HistoryTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Account.Portfolio.History

  describe "list/1" do
    test "gets the list of account portfolio history successfully" do
      use_cassette "account_history/list_success" do
        assert {:ok,
                %{
                  timestamp: _timestamp,
                  equity: _equity,
                  profit_loss: _profit_loss,
                  profit_loss_pct: _profit_loss_pct,
                  base_value: _base_value,
                  timeframe: "1D"
                }} = History.list()
      end
    end
  end
end
