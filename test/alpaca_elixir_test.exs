defmodule AlpacaElixirTest do
  use ExUnit.Case
  doctest AlpacaElixir

  test "greets the world" do
    assert AlpacaElixir.hello() == :world
  end
end
