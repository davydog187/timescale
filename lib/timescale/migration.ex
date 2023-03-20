defmodule Timescale.Migration do
  @moduledoc """
  This module provides helpers for installing TimescaleDB, as well as creating, modifying, and configuring Timescale resources.
  """

  import Timescale.MigrationUtils

  @doc """
  Adds TimescaleDB as a Postgres extension

  Options:
  - `:schema` `string` The name of the schema in which to install the extensions' objects.
  - `:version` `string` The version of the extension to install.
  - `:cascade` `true|false` In the up direction, automatically install any extensions that this extension depends on that are not already installed. In the down direction, forcibly remove any dependent objects.
  - `:if_exists` `true|false` In the down direction, drop extension only if it exists. Default: `true`
  - `:if_not_exists` `true|false` In the up direction, create extension only if it doesn't exists. Default: `true`
  """
  defmacro create_timescaledb_extension(opts \\ []) do
    schema = if opts[:schema], do: "SCHEMA #{opts[:schema]}"
    version = if opts[:version], do: "VERSION '#{opts[:version]}'"
    cascade = if opts[:cascade], do: "CASCADE"
    if_exists = if Keyword.get(opts, :if_exists, true), do: "IF EXISTS"
    if_not_exists = if Keyword.get(opts, :if_not_exists, true), do: "IF NOT EXISTS"

    quote bind_quoted: [
            schema: schema,
            version: version,
            cascade: cascade,
            if_exists: if_exists,
            if_not_exists: if_not_exists
          ] do
      Ecto.Migration.execute(
        trim("CREATE EXTENSION #{if_not_exists} timescaledb #{schema} #{version} #{cascade}"),
        trim("DROP EXTENSION #{if_exists} timescaledb #{cascade}")
      )
    end
  end

  @doc """
  Drops TimescaleDB as a Postgres extension

  Options:
  - `:cascade` `true|false` In the up direction, automatically install any extensions that this extension depends on that are not already installed. In the down direction, forcibly remove any dependent objects.
  - `:if_exists` `true|false` Drop extension only if it exists. Default: `true`

  Down direction options:
  - `:if_not_exist` `true|false` In the down direction, create extension only if it doesn't exists. Default: `true`
  - `:cascade` `true|false` See earlier `:cascade` option.
  - `:schema` `string` The name of the schema in which to install the extensions' objects.
  - `:version` `string` The version of the extension to install.
  """
  defmacro drop_timescaledb_extension(opts \\ []) do
    if_exists = if Keyword.get(opts, :if_exists, true), do: "IF EXISTS"
    if_not_exists = if Keyword.get(opts, :if_not_exists, true), do: "IF NOT EXISTS"
    cascade = if opts[:cascade], do: "CASCADE"
    schema = if opts[:schema], do: "SCHEMA #{opts[:schema]}"
    version = if opts[:version], do: "VERSION '#{opts[:version]}'"

    quote bind_quoted: [
            schema: schema,
            version: version,
            cascade: cascade,
            if_exists: if_exists,
            if_not_exists: if_not_exists
          ] do
      Ecto.Migration.execute(
        trim("DROP EXTENSION #{if_exists} timescaledb #{cascade}"),
        trim("CREATE EXTENSION #{if_not_exists} timescaledb #{schema} #{version} #{cascade}")
      )
    end
  end

  @doc """
  Adds the [TimescaleDB toolkit](https://docs.timescale.com/timescaledb/latest/how-to-guides/hyperfunctions/install-toolkit/#install-and-update-timescaledb-toolkit) as a Postgres Extension

  Options:
  - `:schema` `string` The name of the schema in which to install the extensions' objects.
  - `:version` `string` The version of the extension to install.
  - `:cascade` `true|false` In the up direction, automatically install any extensions that this extension depends on that are not already installed. In the down direction, forcibly remove any dependent objects.
  - `:if_not_exist` `true|false` Create extension only if it doesn't exists. Default: `true`

  Down direction options:
  - `:if_exists` `true|false` In the up direction, drop extension only if it exists. Default: `true`
  - `:cascade` `true|false` See earlier `:cascade` option.
  """
  defmacro create_timescaledb_toolkit_extension(opts \\ []) do
    schema = if opts[:schema], do: "SCHEMA #{opts[:schema]}"
    version = if opts[:version], do: "VERSION '#{opts[:version]}'"
    cascade = if opts[:cascade], do: "CASCADE"
    if_exists = if Keyword.get(opts, :if_exists, true), do: "IF EXISTS"
    if_not_exists = if Keyword.get(opts, :if_not_exists, true), do: "IF NOT EXISTS"

    quote bind_quoted: [
            schema: schema,
            version: version,
            cascade: cascade,
            if_exists: if_exists,
            if_not_exists: if_not_exists
          ] do
      Ecto.Migration.execute(
        trim(
          "CREATE EXTENSION #{if_not_exists} timescaledb_toolkit #{schema} #{version} #{cascade}"
        ),
        trim("DROP EXTENSION #{if_exists} timescaledb_toolkit #{cascade}")
      )
    end
  end

  @doc """
  Updates the existing [TimescaleDB](https://docs.timescale.com/timescaledb/latest/how-to-guides/hyperfunctions/install-toolkit/#install-and-update-timescaledb-toolkit) extension

  Irreversible migration.

  Options:
  - `:set_schema` `string` The name of the schema in which to update the extensions' objects.
    If this is set, the `to_version` option will be ignored.
    If you need to set the schema and upate to a version, call this function twice with each option.
  - `:to_version` `string` In the up direction, the version of the extension to update to.
  """
  defmacro update_timescaledb_extension(opts \\ []) do
    if schema = opts[:schema] do
      quote bind_quoted: [schema: schema] do
        Ecto.Migration.execute("ALTER EXTENSION timescaledb SET SCHEMA #{schema}")
      end
    else
      to_version = if opts[:to_version], do: "TO '#{opts[:to_version]}'"

      quote bind_quoted: [to_version: to_version] do
        Ecto.Migration.execute(trim("ALTER EXTENSION timescaledb UPDATE #{to_version}"), "")
      end
    end
  end

  @doc """
  Updates the existing [TimescaleDB toolkit](https://docs.timescale.com/timescaledb/latest/how-to-guides/hyperfunctions/install-toolkit/#install-and-update-timescaledb-toolkit) extension

  Irreversible migration.

  Options:
  - `:to_version` `string` In the up direction, the version of the extension to update to.
  """
  defmacro update_timescaledb_toolkit_extension(opts \\ []) do
    if opts[:schema],
      do:
        raise(Timescale.MigrationArgError,
          function: :update_timescaledb_toolkit_extension,
          invalid_args: [:schema]
        )

    to_version = if opts[:to_version], do: "TO '#{opts[:to_version]}'"

    quote bind_quoted: [to_version: to_version] do
      Ecto.Migration.execute(trim("ALTER EXTENSION timescaledb_toolkit UPDATE #{to_version}"))
    end
  end

  @doc """
  Drops the [TimescaleDB toolkit](https://docs.timescale.com/timescaledb/latest/how-to-guides/hyperfunctions/install-toolkit/#install-and-update-timescaledb-toolkit) as a Postgres Extension

  Options:
  - `:cascade` `true|false` Forcibly remove dependant objects.
  - `:if_exists` `true|false` Drop extension only if it exists. Default: `true`

  Down direction options:
  - `:if_not_exist` `true|false` Create extension only if it doesn't exists. Default: `true`
  - `:schema` `string` The name of the schema in which to install the extensions' objects.
  - `:version` `string` The version of the extension to install.
  """
  defmacro drop_timescaledb_toolkit_extension(opts \\ []) do
    if_exists = if Keyword.get(opts, :if_exists, true), do: "IF EXISTS"
    if_not_exists = if Keyword.get(opts, :if_not_exists, true), do: "IF NOT EXISTS"
    cascade = if opts[:cascade], do: "CASCADE"
    schema = if opts[:schema], do: "SCHEMA #{opts[:schema]}"
    version = if opts[:version], do: "VERSION '#{opts[:version]}'"

    quote bind_quoted: [
            schema: schema,
            version: version,
            cascade: cascade,
            if_exists: if_exists,
            if_not_exists: if_not_exists
          ] do
      Ecto.Migration.execute(
        trim("DROP EXTENSION #{if_exists} timescaledb_toolkit #{cascade}"),
        trim(
          "CREATE EXTENSION #{if_not_exists} timescaledb_toolkit #{schema} #{version} #{cascade}"
        )
      )
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
