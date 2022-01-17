defmodule Alpaca.CalendarTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Alpaca.Calendar

  describe "list/1" do
    test "gets the list of calendar info successfully" do
      use_cassette "calendar/list_success" do
        assert {:ok, dates} = Calendar.list()
        assert length(dates) == 15_136
      end
    end

    test "gets the list of calendar info in a time range successfully" do
      use_cassette "calendar/list_range_success" do
        assert {:ok, dates} = Calendar.list(%{start: ~D[2020-02-10], end: ~D[2020-03-01]})
        assert length(dates) == 14
      end
    end
  end
end
