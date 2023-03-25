defmodule Timescale.Hyperfunctions.Toolkit do
  @moduledoc """
  Some hyperfunctions are included in the default TimescaleDB product. For additional hyperfunctions,
  you need to install the TimescaleDB Toolkit PostgreSQL extension.

  All of the hyperfunctions in this module require the Toolkit to be installed, or else you will
  encounter an error.

  For installation instructions, see the [Timescale Docs](https://docs.timescale.com/timescaledb/latest/how-to-guides/hyperfunctions/install-toolkit/#install-and-update-timescaledb-toolkit)

  Install the Postgres extension with `Timescale.Migration.create_timescaledb_toolkit_extension/0`
  """

  @doc """
  Perform analysis of financial asset data. These specialized hyperfunctions make it easier to write
  financial analysis queries that involve candlestick data.

  They help you answer questions such as:
  - What are the opening and closing prices of these stocks?
  - When did the highest price occur for this stock?

  This function group uses the two-step aggregation pattern. In addition to the usual aggregate function,
  candlestick_agg, it also includes the pseudo-aggregate function `candlestick`. candlestick_agg produces a
  candlestick aggregate from raw tick data, which can then be used with the accessor and rollup functions
  in this group. candlestick takes pre-aggregated data and transforms it into the same format that
  candlestick_agg produces. This allows you to use the accessors and rollups with existing candlestick data.


  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg/#candlestick_agg-functions)
  """
  defmacro candlestick_agg(price, volume, timestamp) do
    quote do
      fragment("candlestick_agg(?, ?, ?)", unquote(timestamp), unquote(price), unquote(volume))
    end
  end

  @doc """
  This function transforms pre-aggregated candlestick data into a `candlestick` aggregate object. This object
  contains the data in the correct form to use with the accessors and rollups in this function group.

  If you're starting with raw tick data rather than candlestick data, use `candlestick_agg` instead.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#candlestick)
  """
  defmacro candlestick(open, high, low, close, volume, timestamp) do
    quote do
      fragment(
        "candlestick(?, ?, ?, ?, ?, ?)",
        unquote(timestamp),
        unquote(open),
        unquote(high),
        unquote(low),
        unquote(close),
        unquote(volume)
      )
    end
  end

  @doc """
  Combine multiple intermediate candlestick aggregates, produced by `candlestick_agg` or `candlestick`, into
  a single intermediate candlestick aggregate.

  For example, you can use rollup to combine candlestick aggregates from 15-minute buckets into daily buckets.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#rollup)
  """

  defmacro rollup(candlestick) do
    quote do
      fragment("rollup(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the closing price from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#close)
  """
  defmacro close(candlestick) do
    quote do
      fragment("close(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the timestamp corresponding to the close time from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#close_time)
  """
  defmacro close_time(candlestick) do
    quote do
      fragment("close_time(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the opening price from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#open)
  """
  defmacro open(candlestick) do
    quote do
      fragment("open(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the timestamp corresponding to the open time from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#open_time)
  """
  defmacro open_time(candlestick) do
    quote do
      fragment("open_time(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the high price from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#high)
  """
  defmacro high(candlestick) do
    quote do
      fragment("high(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the timestamp corresponding to the high time from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#high_time)
  """
  defmacro high_time(candlestick) do
    quote do
      fragment("high_time(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the low price from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#low)
  """
  defmacro low(candlestick) do
    quote do
      fragment("low(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the timestamp corresponding to the low time from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#low_time)
  """
  defmacro low_time(candlestick) do
    quote do
      fragment("low_time(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the total volume from a `candlestick` aggregate.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#volume)
  """
  defmacro volume(candlestick) do
    quote do
      fragment("volume(?)", unquote(candlestick))
    end
  end

  @doc """
  Get the Volume Weighted Average Price from a `candlestick` aggregate.

  For Candlesticks constructed from data that is already aggregated, the Volume Weighted Average Price
  is calculated using the typical price for each period (where the typical price refers to the
  arithmetic mean of the high, low, and closing prices).

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/financial-analysis/candlestick_agg#vwap)
  """
  defmacro vwap(candlestick) do
    quote do
      fragment("vwap(?)", unquote(candlestick))
    end
  end
end
