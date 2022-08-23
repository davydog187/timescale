defmodule Timescale.HyperfunctionTest do
  use Timescale.SQLCase

  alias TimescaleApp.Table

  import Timescale.Hyperfunctions
  import Ecto.Query, warn: false, except: [first: 2, last: 2]

  test "first/2 generates a valid query" do
    assert_sql(
      from(r in Table, select: first(r.a, r.timestamp)),
      ~s[SELECT first(m0."a", m0."timestamp") FROM "my_table" AS m0]
    )
  end

  test "last/2 generates a valid query" do
    assert_sql(
      from(r in Table, select: last(r.a, r.timestamp)),
      ~s[SELECT last(m0."a", m0."timestamp") FROM "my_table" AS m0]
    )
  end

  test "time_bucket/2 generates a valid query" do
    assert_sql(
      from(t in Table, select: time_bucket(t.timestamp, "5 minutes")),
      ~s[SELECT time_bucket('5 minutes', m0."timestamp") FROM "my_table" AS m0]
    )
  end

  test "time_bucket/3 generates a valid query with optional params" do
    assert_sql(
      from(t in Table,
        select: time_bucket(t.timestamp, "5 minutes", origin: "1900-01-01", offset: "2.5 minutes")
      ),
      ~s[SELECT time_bucket('5 minutes', m0."timestamp", origin => '1900-01-01', offset => '2.5 minutes') FROM "my_table" AS m0]
    )

    assert_sql(
      from(t in Table,
        select: time_bucket(t.timestamp, "5 minutes", offset: "2.5 minutes", origin: "1900-01-01")
      ),
      ~s[SELECT time_bucket('5 minutes', m0."timestamp", offset => '2.5 minutes', origin => '1900-01-01') FROM "my_table" AS m0]
    )
  end

  test "time_bucket_ng/2 generates a valid query" do
    assert_sql(
      from(t in Table, select: time_bucket_ng(t.timestamp, "5 years")),
      ~s[SELECT time_bucket_ng('5 years', m0."timestamp") FROM "my_table" AS m0]
    )
  end

  test "time_bucket_ng/3 generates a valid query with optional params" do
    assert_sql(
      from(t in Table,
        select:
          time_bucket_ng(t.timestamp, "5 minutes", origin: "1900-01-01", timezone: "Europe/Athens")
      ),
      ~s[SELECT time_bucket_ng('5 minutes', m0."timestamp", origin => '1900-01-01', timezone => 'Europe/Athens') FROM "my_table" AS m0]
    )

    assert_sql(
      from(t in Table,
        select:
          time_bucket_ng(t.timestamp, "5 minutes", timezone: "Europe/Athens", origin: "1900-01-01")
      ),
      ~s[SELECT time_bucket_ng('5 minutes', m0."timestamp", timezone => 'Europe/Athens', origin => '1900-01-01') FROM "my_table" AS m0]
    )
  end
end
