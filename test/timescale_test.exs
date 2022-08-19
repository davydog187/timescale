defmodule TimescaleTest do
  use ExUnit.Case
  doctest Timescale

  test "greets the world" do
    assert Timescale.hello() == :world
  end
end
