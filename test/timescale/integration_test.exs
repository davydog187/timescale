defmodule Timescale.IntegrationTest do
  use Timescale.DataCase

  import Timescale.Hyperfunctions
  import Ecto.Query, warn: false, except: [first: 2, last: 2]

  alias TimescaleApp.Repo
  alias TimescaleApp.Table
  alias TimescaleApp.TZTable

  test "first/2 returns the first value" do
    naive_fixture(1.0)
    naive_fixture(2.0)
    naive_fixture(3.0)

    assert Repo.one(from(t in Table, select: first(t.field, t.timestamp))) == 1.0
  end

  test "last/2 returns the last value" do
    naive_fixture(1.0)
    naive_fixture(2.0)
    naive_fixture(3.0)

    assert Repo.one(from(t in Table, select: last(t.field, t.timestamp))) == 3.0
  end

  test "histogram/4 returns a histogram" do
    for x <- 1..100, do: naive_fixture(x / 1.0)

    assert Repo.one(from(t in Table, select: histogram(t.field, 0, 100.0, 5))) == [
             0,
             19,
             20,
             20,
             20,
             20,
             1
           ]
  end

  describe "time_bucket/3" do
    test "buckets each timestamp by the given interval" do
      naive_fixture(0.0, ~N[1989-09-22 12:00:00.000000])
      naive_fixture(1.0, ~N[1989-09-22 12:01:00.000000])
      naive_fixture(2.0, ~N[1989-09-22 12:02:00.000000])
      naive_fixture(3.0, ~N[1989-09-22 12:03:00.000000])
      naive_fixture(4.0, ~N[1989-09-22 12:04:00.000000])
      naive_fixture(5.0, ~N[1989-09-22 12:05:00.000000])

      assert Repo.all(from(t in Table, select: {t.field, time_bucket(t.timestamp, "2 minutes")})) ==
               [
                 {0.0, ~N[1989-09-22 12:00:00.000000]},
                 {1.0, ~N[1989-09-22 12:00:00.000000]},
                 {2.0, ~N[1989-09-22 12:02:00.000000]},
                 {3.0, ~N[1989-09-22 12:02:00.000000]},
                 {4.0, ~N[1989-09-22 12:04:00.000000]},
                 {5.0, ~N[1989-09-22 12:04:00.000000]}
               ]
    end

    test "can set an origin with a named option" do
      naive_fixture(0.0, ~N[1989-09-22 12:00:00.000000])
      naive_fixture(1.0, ~N[1989-09-22 12:01:00.000000])
      naive_fixture(2.0, ~N[1989-09-22 12:02:00.000000])
      naive_fixture(3.0, ~N[1989-09-22 12:03:00.000000])
      naive_fixture(4.0, ~N[1989-09-22 12:04:00.000000])
      naive_fixture(5.0, ~N[1989-09-22 12:05:00.000000])

      origin = ~N[1989-09-22 11:59:00.000000]

      assert Repo.all(
               from(t in Table,
                 select: {t.field, time_bucket(t.timestamp, "2 minutes", origin: ^origin)}
               )
             ) == [
               {0.0, ~N[1989-09-22 11:59:00.000000]},
               {1.0, ~N[1989-09-22 12:01:00.000000]},
               {2.0, ~N[1989-09-22 12:01:00.000000]},
               {3.0, ~N[1989-09-22 12:03:00.000000]},
               {4.0, ~N[1989-09-22 12:03:00.000000]},
               {5.0, ~N[1989-09-22 12:05:00.000000]}
             ]
    end

    test "can bucket by months" do
      timezone_fixture(0.0, ~U[2020-01-22 12:00:00.000000Z])
      timezone_fixture(1.0, ~U[2020-02-22 12:01:00.000000Z])
      timezone_fixture(2.0, ~U[2020-03-22 12:02:00.000000Z])
      timezone_fixture(3.0, ~U[2020-04-22 12:03:00.000000Z])
      timezone_fixture(4.0, ~U[2020-05-22 12:04:00.000000Z])
      timezone_fixture(5.0, ~U[2020-06-22 12:05:00.000000Z])

      assert Repo.all(from(t in TZTable, select: {t.field, time_bucket(t.timestamp, "2 month")})) ==
               [
                 {0.0, ~N[2020-01-01 00:00:00.000000]},
                 {1.0, ~N[2020-01-01 00:00:00.000000]},
                 {2.0, ~N[2020-03-01 00:00:00.000000]},
                 {3.0, ~N[2020-03-01 00:00:00.000000]},
                 {4.0, ~N[2020-05-01 00:00:00.000000]},
                 {5.0, ~N[2020-05-01 00:00:00.000000]}
               ]
    end
  end

  def naive_fixture(value, timestamp \\ NaiveDateTime.utc_now()) do
    Repo.insert!(%Table{field: value, timestamp: timestamp})
  end

  def timezone_fixture(value, timestamp \\ DateTime.utc_now()) do
    Repo.insert!(%TZTable{field: value, timestamp: timestamp})
  end
end
