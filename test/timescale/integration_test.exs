defmodule Timescale.IntegrationTest do
  use Timescale.DataCase

  import Timescale.Hyperfunctions
  import Ecto.Query, warn: false, except: [first: 2, last: 2]

  alias TimescaleApp.Repo
  alias TimescaleApp.Table

  setup do
    fixture(1.0)
    fixture(2.0)
    fixture(3.0)

    :ok
  end

  test "first/2 returns the first value" do
    assert Repo.one(from(t in Table, select: first(t.field, t.timestamp))) == 1.0
  end

  test "last/2 returns the last value" do
    assert Repo.one(from(t in Table, select: last(t.field, t.timestamp))) == 3.0
  end

  def fixture(value, timestamp \\ NaiveDateTime.utc_now()) do
    Repo.insert!(%Table{field: value, timestamp: timestamp})
  end
end
