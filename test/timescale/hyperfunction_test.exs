defmodule Timescale.HyperfunctionTest do
  use Timescale.SQLCase

  import Timescale.Hyperfunctions
  import Ecto.Query, warn: false, except: [first: 2, last: 2]

  alias TimescaleApp.Table

  test "first/2 generates a valid query" do
    assert_sql(
      from(r in Table, select: first(r.field, r.timestamp)),
      ~s[SELECT first(t0."field", t0."timestamp") FROM "test_hypertable" AS t0]
    )
  end

  test "histogram/4 generates a valid query" do
    assert_sql(
      from(r in Table, select: histogram(r.field, 20, 60, 5)),
      ~s[SELECT histogram(t0."field", 20, 60, 5) FROM "test_hypertable" AS t0]
    )
  end

  test "last/2 generates a valid query" do
    assert_sql(
      from(r in Table, select: last(r.field, r.timestamp)),
      ~s[SELECT last(t0."field", t0."timestamp") FROM "test_hypertable" AS t0]
    )
  end

  test "time_bucket/2 generates a valid query" do
    assert_sql(
      from(t in Table, select: time_bucket(t.timestamp, "5 minutes")),
      ~s[SELECT time_bucket('5 minutes', t0."timestamp") FROM "test_hypertable" AS t0]
    )
  end

  test "time_bucket/2 should raise an error if an invalid option is provided" do
    assert_raise Timescale.OptionalArgError,
                 "The time_bucket TimescaleDB function does support the following options: [:invalid_opt]",
                 fn ->
                   Code.eval_string("""
                   import Ecto.Query
                   import Timescale.Hyperfunctions

                   from(t in Table,
                     select: time_bucket(t.timestamp, "5 minutes", invalid_opt: "bad data")
                   )
                   """)
                 end
  end

  test "time_bucket/3 generates a valid query with optional params" do
    assert_sql(
      from(t in Table,
        select: time_bucket(t.timestamp, "5 minutes", origin: "1900-01-01", offset: "2.5 minutes")
      ),
      ~s[SELECT time_bucket('5 minutes', t0."timestamp", origin => '1900-01-01', offset => '2.5 minutes') FROM "test_hypertable" AS t0]
    )

    assert_sql(
      from(t in Table,
        select: time_bucket(t.timestamp, "5 minutes", offset: "2.5 minutes", origin: "1900-01-01")
      ),
      ~s[SELECT time_bucket('5 minutes', t0."timestamp", offset => '2.5 minutes', origin => '1900-01-01') FROM "test_hypertable" AS t0]
    )
  end

  test "time_bucket_gapfill/2 generates a valid query" do
    assert_sql(
      from(t in Table, select: time_bucket_gapfill(t.timestamp, "5 minutes")),
      ~s[SELECT time_bucket_gapfill('5 minutes', t0."timestamp") FROM "test_hypertable" AS t0]
    )
  end
end
