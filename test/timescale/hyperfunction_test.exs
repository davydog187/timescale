defmodule Timescale.HyperfunctionTest do
  use Timescale.SQLCase

  import Timescale.Hyperfunctions
  import Ecto.Query, warn: false, except: [first: 2, last: 2]

  alias TimescaleApp.Table

  test "first/2 generates a valid query" do
    assert_sql(
      from(r in Table, select: first(r.a, r.timestamp)),
      ~s[SELECT first(m0."a", m0."timestamp") FROM "my_table" AS m0]
    )
  end

  test "histogram/4 generates a valid query" do
    assert_sql(
      from(r in Table, select: histogram(r.a, 20, 60, 5)),
      ~s[SELECT histogram(m0."a", 20, 60, 5) FROM "my_table" AS m0]
    )
  end

  test "last/2 generates a valid query" do
    assert_sql(
      from(r in Table, select: last(r.a, r.timestamp)),
      ~s[SELECT last(m0."a", m0."timestamp") FROM "my_table" AS m0]
    )
  end
end
