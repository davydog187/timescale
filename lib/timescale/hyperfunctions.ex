defmodule Timescale.Hyperfunctions do
  @moduledoc """
  Timescale hyperfunctions are a specialized set of functions that allow you to analyze time-series data.
  You can use hyperfunctions to analyze anything you have stored as time-series data, including IoT devices,
  IT systems, marketing analytics, user behavior, financial metrics, and cryptocurrency.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/)
  """

  @doc """
  The first aggregate allows you to get the value of one column as ordered by another.
  For example, `first(temperature, time)` returns the earliest temperature value based on time within an aggregate group.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/first/)
  """
  defmacro first(field, time) do
    quote do
      fragment("first(?, ?)", unquote(field), unquote(time))
    end
  end

  @doc """
  The last aggregate allows you to get the value of one column as ordered by another.
  For example, `last(temperature, time)` returns the latest temperature value based on time within an aggregate group.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/last/)
  """
  defmacro last(field, time) do
    quote do
      fragment("last(?, ?)", unquote(field), unquote(time))
    end
  end

  @doc """
  Allows you to aggregate results into arbitrary time buckets. You can group by seconds, minutes, hours, days
  and also weeks.
  For example, `time_bucket(timestamp, "5 minutes")` would allow you to group results into 5 minute buckets.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/time_bucket/)
  """
  defmacro time_bucket(field, time_bucket) do
    quote do
      fragment("time_bucket(?, ?)", unquote(time_bucket), unquote(field))
    end
  end

  @doc """
  This experimental TimescaleDB function works identically to `time_bucket/2` with the added benefit that
  you can aggregate by month, year or timezone.
  For example, `time_bucket_ng(timestamp, "5 years")` would allow you to group results into 5 year buckets.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/time_bucket_ng/)
  """
  defmacro time_bucket_ng(field, time_bucket) do
    quote do
      fragment("time_bucket_ng(?, ?)", unquote(time_bucket), unquote(field))
    end
  end
end
