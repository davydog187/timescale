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
  Adds the [TimescaleDB toolkit](https://docs.timescale.com/timescaledb/latest/how-to-guides/hyperfunctions/install-toolkit/#install-and-update-timescaledb-toolkit) as a Postgres Extension
  """
  defmacro create_timescaledb_toolkit_extension do
    quote do
      Ecto.Migration.execute("CREATE EXTENSION IF NOT EXISTS timescaledb_toolkit CASCADE")
    end
  end

  @doc """
  Drops the [TimescaleDB toolkit](https://docs.timescale.com/timescaledb/latest/how-to-guides/hyperfunctions/install-toolkit/#install-and-update-timescaledb-toolkit) as a Postgres Extension
  """
  defmacro drop_timescaledb_toolkit_extension do
    quote do
      Ecto.Migration.execute("DROP EXTENSION IF EXISTS timescaledb_toolkit CASCADE")
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

  ## Required arguments
  * `:segment_by` - Column list on which to key the compressed segments
  """
  defmacro enable_hypertable_compression(table, args \\ []) do
    segment_by = Keyword.fetch!(args, :segment_by)

    quote bind_quoted: [table: table, segment_by: segment_by] do
      Ecto.Migration.execute(
        "ALTER TABLE #{table} SET (timescaledb.compress = true, timescaledb.compress_segmentby = '#{segment_by}')"
      )
    end
  end

  @doc """
  Disables compression on an existing hypertable. Note that chunks must be decompressed before its called

  See the [ALTER TABLE (Compression)](https://docs.timescale.com/api/latest/compression/alter_table_compression/) documentation
  """
  defmacro disable_hypertable_compression(table) do
    quote bind_quoted: [table: table] do
      Ecto.Migration.execute("ALTER TABLE #{table} SET (timescaledb.compress = false)")
    end
  end

  @doc """
  Adds a compression policy to a hypertable using the [add_compression_policy](https://docs.timescale.com/api/latest/compression/add_compression_policy/#add-compression-policy)
  function
  """
  defmacro add_compression_policy(hypertable, compress_after, opts \\ []) do
    hypertable = normalize_arg(hypertable)
    compress_after = normalize_arg(compress_after)
    required_args = [{hypertable, :text}, {compress_after, :interval}]

    select_migration(:add_compression_policy, required_args, opts, [
      :if_not_exists
    ])
  end

  @doc """
  Removes a compression policy from a hypertable using the [remove_compression_policy](https://docs.timescale.com/api/latest/compression/remove_compression_policy/#remove-compression-policy)
  function
  """
  defmacro remove_compression_policy(hypertable, opts \\ []) do
    hypertable = normalize_arg(hypertable)
    required_args = [{hypertable, :text}]

    select_migration(:remove_compression_policy, required_args, opts, [
      :if_exists
    ])
  end
end
