defmodule Timescale.Migration do
  @moduledoc """
  This module provides helpers for installing TimescaleDB, as well as creating, modifying, and configuring Timescale resources.
  """

  @doc """
  Adds TimescaleDB as a Postgres extension
  """
  defmacro create_timescaledb_extension do
    quote do
      execute("CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE")
    end
  end

  @doc """
  Drops TimescaleDB as a Postgres extension
  """
  defmacro drop_timescaledb_extension do
    quote do
      execute("DROP EXTENSION IF EXISTS timescaledb CASCADE")
    end
  end

  @doc """
  Creates a new [hypertable](https://docs.timescale.com/api/latest/hypertable/create_hypertable/#create-hypertable) in an Ecto Migration.

  ```elixir
  create_hypertable(:conditions, :time)
  ```
  """
  defmacro create_hypertable(table, field, opts \\ []) do
    opts = opts_to_sql_arg(opts)

    quote bind_quoted: [table: table, field: field, opts: opts] do
      execute("SELECT create_hypertable('#{table}', '#{field}'#{opts})")
    end
  end

  @doc """
  Enables compression on an existing hypertable

  See the [ALTER TABLE (Compression)](https://docs.timescale.com/api/latest/compression/alter_table_compression/) documentation
  """
  defmacro enable_hypertable_compression(table, opts) do
    segment_by = Keyword.fetch!(opts, :segment_by)

    quote bind_quoted: [table: table, segment_by: segment_by] do
      execute(
        "ALTER TABLE #{table} SET (timescaledb.compress, timescaledb.compress_segmentby = '#{segment_by}')"
      )
    end
  end

  @doc """
  Adds a compression policy to a hypertable using the [add_compression_policy](https://docs.timescale.com/api/latest/compression/add_compression_policy/#add-compression-policy)
  function
  """
  defmacro add_compression_policy(table, compress_after) do
    quote bind_quoted: [table: table, compress_after: compress_after] do
      execute("SELECT add_compression_policy('#{table}', #{compress_after})")
    end
  end

  defp opts_to_sql_arg([]), do: ""

  defp opts_to_sql_arg(opts) do
    Enum.map_join(opts, ", ", fn {k, v} ->
      "#{k} => #{v}"
    end)
  end
end
