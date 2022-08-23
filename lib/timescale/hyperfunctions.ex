defmodule Timescale.Hyperfunctions do
  @moduledoc """
  Timescale hyperfunctions are a specialized set of functions that allow you to analyze time-series data.
  You can use hyperfunctions to analyze anything you have stored as time-series data, including IoT devices,
  IT systems, marketing analytics, user behavior, financial metrics, and cryptocurrency.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/)
  """

  import Timescale.QueryUtils

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

  This function also accepts the following optional parameters (passed in as a keyword list):

  - `:offset`: The time interval used to offset all of the timebuckets by. (Postgres type: `INTERVAL`)
  - `:origin`: The timestamp used to align all of the time buckets. (Postgres type: `TIMESTAMP`)

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/time_bucket/)
  """
  defmacro time_bucket(field, time_bucket, optional_args \\ []) do
    dynamic_function_fragment(:time_bucket, [time_bucket, field], optional_args)
  end

  @doc """
  This experimental TimescaleDB function works identically to `time_bucket/2` with the added benefit that
  you can aggregate by month, year or timezone.
  For example, `time_bucket_ng(timestamp, "5 years")` would allow you to group results into 5 year buckets.

  - `:origin`: The timestamp used to align all of the time buckets. (Postgres type: `DATE`, `TIMESTAMP`, or `TIMESTAMPZ`)
  - `:timezone`: The name of the timezone. (Postgres type: `TEXT`)

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/time_bucket_ng/)
  """
  defmacro time_bucket_ng(field, time_bucket, optional_args \\ []) do
    dynamic_function_fragment(:time_bucket_ng, [time_bucket, field], optional_args)
  end
end
