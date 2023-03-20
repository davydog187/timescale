defmodule Timescale.ToolkitTest do
  use Timescale.SQLCase

  import Timescale.Hyperfunctions
  import Timescale.Hyperfunctions.Toolkit
  import Ecto.Query, warn: false, except: [first: 2, last: 2]

  alias TimescaleApp.Table

  test "candlestick_agg/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: candlestick_agg(r.price, r.volume, r.timestamp)),
      ~s[SELECT candlestick_agg(t0."timestamp", t0."price", t0."volume") FROM "test_hypertable" AS t0]
    )
  end

  test "candlestick/6 generates a valid query" do
    assert_sql(
      from(r in Table, select: candlestick(r.open, r.high, r.low, r.close, r.volume, r.timestamp)),
      ~s[SELECT candlestick(t0."timestamp", t0."open", t0."high", t0."low", t0."close", t0."volume") FROM "test_hypertable" AS t0]
    )
  end

  test "open/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> open()),
      ~s[SELECT open(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "open_time/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> open_time()),
      ~s[SELECT open_time(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "close/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> close()),
      ~s[SELECT close(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "close_time/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> close_time()),
      ~s[SELECT close_time(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "high/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> high()),
      ~s[SELECT high(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "high_time/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> high_time()),
      ~s[SELECT high_time(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "low/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> low()),
      ~s[SELECT low(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "low_time/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> low_time()),
      ~s[SELECT low_time(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "volume/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> volume()),
      ~s[SELECT volume(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "vwap/3 generates a valid query" do
    assert_sql(
      from(r in Table, select: r.price |> candlestick_agg(r.volume, r.timestamp) |> vwap()),
      ~s[SELECT vwap(candlestick_agg(t0."timestamp", t0."price", t0."volume")) FROM "test_hypertable" AS t0]
    )
  end

  test "rollup/1 generates a valid query" do
    assert_sql(
      from(r in Table,
        select: %{ts: time_bucket(r.timestamp, "5 minutes"), r: rollup(r.candlestick)}
      ),
      ~s[SELECT time_bucket('5 minutes', t0."timestamp"), rollup(t0."candlestick") FROM "test_hypertable" AS t0]
    )
  end
end
