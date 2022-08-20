defmodule Timescale.HyperfunctionTest do
  use Timescale.SQLCase

  alias TimescaleApp.Table

  import Timescale.Hyperfunctions
  import Ecto.Query, warn: false, except: [last: 2]

  test "last/2 generates a valid query" do
    assert_sql(
      from(r in Table, select: last(r.a, r.timestamp)),
      ~s[SELECT last(m0."a", m0."timestamp") FROM "my_table" AS m0]
    )
  end
end
