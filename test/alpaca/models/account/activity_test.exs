defmodule Alpaca.Account.ActivityTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Account.Activity

  describe "list/1" do
    test "gets the list of account activities successfully" do
      use_cassette "account_activity/list_success" do
        assert {:ok, account_activities} = Activity.list()
        assert length(account_activities) == 8
      end
    end

    test "gets the list of account activities successfully with defined types" do
      use_cassette "account_activity/list_specific_success" do
        assert {:ok, account_activities} = Activity.list(%{activity_types: "FILL,TRANS"})
        assert length(account_activities) == 8
      end
    end
  end

  describe "get/1" do
    test "gets the Account Activity successfully by symbol" do
      use_cassette "account_activity/get_success" do
        assert {:ok, account_activities} = Activity.get("FILL")
        assert length(account_activities) == 8

        Enum.each(account_activities, fn aa ->
          assert aa.activity_type == "FILL"
        end)
      end
    end

    test "cannot find the Account Activity" do
      use_cassette "account_activity/get_not_found" do
        activity_type = "FFFFF"
        message = "invalid activity type: FFFFF"

        assert {:error, %{status: 422, body: %{code: 40_010_001, message: ^message}}} =
                 Activity.get(activity_type)
      end
    end
  end
end
