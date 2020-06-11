defmodule Alpaca.Account.ConfigurationTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Account.Configuration

  describe "get/0" do
    test "gets the account config successfully" do
      use_cassette "account_config/get_success" do
        assert {:ok,
                %{
                  dtbp_check: "entry",
                  no_shorting: false,
                  suspend_trade: false,
                  trade_confirm_email: "all"
                }} = Configuration.get()
      end
    end
  end

  describe "edit/0" do
    test "edits the account config successfully" do
      use_cassette "account_config/edit_success" do
        assert {:ok,
                %{
                  dtbp_check: "entry",
                  no_shorting: false,
                  suspend_trade: false,
                  trade_confirm_email: "none"
                }} = Configuration.edit(%{trade_confirm_email: "none"})
      end
    end
  end
end
