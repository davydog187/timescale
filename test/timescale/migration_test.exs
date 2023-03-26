defmodule Timescale.MigrationTest do
  use ExUnit.Case
  use Ecto.Migration

  describe "migration options" do
    test "update_timescaledb_toolkit_extension does not support schema" do
      assert_raise Timescale.MigrationArgError,
                   "The update_timescaledb_toolkit_extension TimescaleDB function does support the following options: [:schema]",
                   fn ->
                     Code.eval_string("""
                     import Ecto.Query
                     import Timescale.Migration

                     update_timescaledb_toolkit_extension(schema: "FOO")
                     """)
                   end
    end
  end

  describe "compression" do
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

    test "remove_compression_policy/3 should raise an error if an invalid option is provided" do
      assert_raise Timescale.MigrationArgError,
                   "The remove_compression_policy TimescaleDB function does support the following options: [:if_not_exists]",
                   fn ->
                     Code.eval_string("""
                     import Ecto.Query
                     import Timescale.Migration

                     remove_compression_policy(:my_ts_table, if_not_exists: true)
                     """)
                   end
    end
  end
end
