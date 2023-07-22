# Timescale

[![Build Status](https://github.com/davydog187/timescale/workflows/CI/badge.svg?branch=main)](https://github.com/davydog187/timescale/actions) [![Hex pm](https://img.shields.io/hexpm/v/timescale.svg?style=flat)](https://hex.pm/packages/timescale) [![Hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/timescale/)

<!-- MDOC !-->

Extends the [Ecto](https://hexdocs.pm/ecto/Ecto.html) DSL for easily working with [TimescaleDB](https://docs.timescale.com/). Already using Ecto and [Postgres](https://hexdocs.pm/ecto_sql/Ecto.Adapters.Postgres.html)? Great, you're all set to start working with time-series data.

### Features

- Easy creation of [hypertables](https://docs.timescale.com/api/latest/hypertable/) in Ecto Migrations
- Leverage TimescaleDB [hyperfunctions](https://docs.timescale.com/api/latest/hyperfunctions/) right inside your Ecto queries
- Configure table [compression policies](https://docs.timescale.com/api/latest/compression/)

## Adding the TimescaleDB extension

1. Make sure your database has Timescale correctly installed
2. Create a new Ecto migration
3. Call the `create_timescaledb_extension/0` and `drop_timescaledb_extension/0` in your migration

E.g.

```elixir
defmodule MyApp.Repo.Migrations.SetupTimescale do
  use Ecto.Migration

  import Timescale.Migration

  def up do
    create_timescaledb_extension()
  end

  def down do
    drop_timescaledb_extension()
  end
end
```

## Using the Library
Here is an intermediate example querying a timescale reading using Timescale [hyperfunctions](https://docs.timescale.com/api/latest/hyperfunctions/) with `timescale`'s Ecto extensions.

For a more comprehensive example you can check out our guide in the docs [here](https://hexdocs.pm/timescale/intro.html#content).

```elixir
import Timescale.Hyperfunctions

Repo.all(
  from(h in "heartbeats",
    where: h.user_id == ^alex_id,
    group_by: selected_as(:minute),
    select: %{
      minute: selected_as(time_bucket(h.timestamp, "1 minute"), :minute),
      bpm: count(h)
    },
    limit: 5
  )
)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `timescale` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:timescale, "~> 0.1.0"}
  ]
end
```

## Installing Postgres / TimescaleDB on MacOS

There are many ways to install PostgreSQL locally, including `Postgres.app`, `Docker`, and building locally. Below is how to install through Homebrew

First, install Postgres

```shell
$ brew install postgresql
$ sudo chown $(whoami) /usr/local/var/postgres
$ initdb /usrl/local/var/postgres
$ createuser -s postgres
$ createdb
```

Make Postgres a service that is started automatically

```shell
$ brew services start postgresql
```

Then install TimescaleDB. For more information about installing TimescaleDB on MacOS, see the [official documentation](https://docs.timescale.com/install/latest/self-hosted/installation-macos/#install-self-hosted-timescaledb-using-homebrew).

```shell
$ brew tap timescale/tap
$ brew install timescaledb

# Add the following to `/opt/homebrew/var/postgres/postgresql.conf`
shared_preload_libraries = 'timescaledb'
```
