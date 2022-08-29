defmodule Timescale.MigrationTest do
  use ExUnit.Case
  use Ecto.Migration

  test "add_compression_policy/3 should raise an error if an invalid option is provided" do
    assert_raise Timescale.MigrationArgError,
                 "The add_compression_policy TimescaleDB function does support the following options: [:invalid_opt]",
                 fn ->
                   Code.eval_string("""
                   import Ecto.Query
                   import Timescale.Migration

                   add_compression_policy(:my_ts_table, "5 hours", invalid_opt: "bad_data")
                   """)
                 end
  end
end
