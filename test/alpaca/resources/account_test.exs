defmodule Alpaca.AccountTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Account

  describe "get/0" do
    test "gets the account successfully" do
      use_cassette "account/get_success" do
        assert {:ok, %Account{} = account} = Account.get()

        assert not is_nil(account.id)
      end
    end

    test "handles error" do
      use_cassette "account/get_failure" do
        assert {:error,
                %{
                  status: 401,
                  body: %{
                    code: 40_110_000,
                    message: "access key verification failed : verification failure"
                  }
                }} = Account.get()
      end
    end
  end
end
