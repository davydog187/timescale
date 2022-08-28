defmodule Timescale.Migration do
  @moduledoc """
  This module provides helpers for installing TimescaleDB, as well as creating, modifying, and configuring Timescale resources.
  """

  import Timescale.MigrationUtils

  @doc """
  Adds TimescaleDB as a Postgres extension
  """
  defmacro create_timescaledb_extension do
    quote do
      Ecto.Migration.execute("CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE")
    end
  end

  @doc """
  Drops TimescaleDB as a Postgres extension
  """
  defmacro drop_timescaledb_extension do
    quote do
      Ecto.Migration.execute("DROP EXTENSION IF EXISTS timescaledb CASCADE")
    end
  end

  @doc """
  Creates a new [hypertable](https://docs.timescale.com/api/latest/hypertable/create_hypertable/#create-hypertable) in an Ecto Migration.

  ```elixir
  create_hypertable(:conditions, :time)
  ```
  """
  defmacro create_hypertable(relation, time_column_name, opts \\ []) do
    relation = normalize_arg(relation)
    time_column_name = normalize_arg(time_column_name)
    required_args = [{relation, :text}, {time_column_name, :text}]

    select_migration(:create_hypertable, required_args, opts, [
      :partitioning_column,
      :number_partitions,
      :chunk_time_interval,
      :create_default_indexes,
      :if_not_exists,
      :partitioning_func,
      :associated_schema_name,
      :associated_table_prefix,
      :migrate_data,
      :time_partitioning_func,
      :replication_factor,
      :data_nodes
    ])
  end

  @doc """
  Enables compression on an existing hypertable

  See the [ALTER TABLE (Compression)](https://docs.timescale.com/api/latest/compression/alter_table_compression/) documentation
  """
  defmacro enable_hypertable_compression(table, opts \\ []) do
    segment_by = Keyword.fetch!(opts, :segment_by)

    quote bind_quoted: [table: table, segment_by: segment_by] do
      Ecto.Migration.execute(
        "ALTER TABLE #{table} SET (timescaledb.compress, timescaledb.compress_segmentby = '#{segment_by}')"
      )
    end
  end

  @doc """
  Adds a compression policy to a hypertable using the [add_compression_policy](https://docs.timescale.com/api/latest/compression/add_compression_policy/#add-compression-policy)
  function
  """
  defmacro add_compression_policy(table, compress_after, opts \\ []) do
    table = normalize_arg(table)
    compress_after = normalize_arg(compress_after)

    select_migration(:add_compression_policy, [table, compress_after], opts, [
      :if_not_exists
    ])
  end
end
