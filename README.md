# Timescale

Extends the[Ecto](https://hexdocs.pm/ecto/Ecto.html) DSL for easily working with [TimescaleDB](https://docs.timescale.com/).

Already using Ecto and [Postgres](https://hexdocs.pm/ecto_sql/Ecto.Adapters.Postgres.html)? Great, you're all set to start working with time-series data.

_Built by [Bitfo](https://www.bitfo.com/careers/)_

### Features

- Easy creation of [hypertables](https://docs.timescale.com/api/latest/hypertable/) in Ecto Migrations
- Leverage TimescaleDB [hyperfunctions](https://docs.timescale.com/api/latest/hyperfunctions/) right inside your Ecto queries
- Configure table [compression policies](https://docs.timescale.com/api/latest/compression/)

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
