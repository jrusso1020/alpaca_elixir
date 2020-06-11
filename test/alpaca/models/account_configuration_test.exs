defmodule Alpaca.AccountConfigurationTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.AccountConfiguration

  describe "get/0" do
    test "gets the account config successfully" do
      use_cassette "account_config/get_success" do
        assert {:ok,
                %{
                  dtbp_check: "entry",
                  no_shorting: false,
                  suspend_trade: false,
                  trade_confirm_email: "all"
                }} = AccountConfiguration.get()
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
                }} = AccountConfiguration.edit(%{trade_confirm_email: "none"})
      end
    end
  end
end
