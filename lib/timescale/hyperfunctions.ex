defmodule Timescale.Hyperfunctions do
  @moduledoc """
  Timescale hyperfunctions are a specialized set of functions that allow you to analyze time-series data.
  You can use hyperfunctions to analyze anything you have stored as time-series data, including IoT devices,
  IT systems, marketing analytics, user behavior, financial metrics, and cryptocurrency.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/)

  ## Approximate Row Count

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/approximate_row_count/)

  Timescale offers a hyperfunction, `approximate_row_count`, for retrieving the approximate row count of hypertables.
  This hyperfunction may be useful for tables with a large number of rows, where the exact number is not needed.

  As Ecto does not support raw SQL through the [Ecto.Query](https://hexdocs.pm/ecto/Ecto.Query.html) API, we have chosen
  not to directly support `approximate_row_count`, for it be an inconsistent API.
  If this is a useful feature to your application, you can use the following code:

  ```elixir
  defmacro approximate_row_count(relation) do
    query = "SELECT approximate_row_count($1::TEXT)"

    quote do
      {:ok, %Postgrex.Result{rows: [[num_rows]]}} =
        Ecto.Adapters.SQL.query(MyApp.MyRepo, unquote(query), [unquote(relation)])

      num_rows
    end
  end
  ```
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
  The histogram function represents the distribution of a set of values as an array of equal-width buckets.
  It partitions the dataset into a specified number of buckets (nbuckets) ranging from the inputted min and max values.

  The return value is an array containing nbuckets+2 buckets, with the middle nbuckets bins for values in the
  stated range, the first bucket at the head of the array for values under the lower min bound, and the last bucket
  for values greater than or equal to the max bound. Each bucket is inclusive on its lower bound,
  and exclusive on its upper bound. Therefore, values equal to the min are included in the bucket starting with min,
  but values equal to the max are in the last bucket.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/histogram/)
  """
  defmacro histogram(field, min, max, buckets) do
    quote do
      fragment(
        "histogram(?, ?, ?, ?)",
        unquote(field),
        unquote(min),
        unquote(max),
        unquote(buckets)
      )
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

  - `:offset` - The time interval used to offset all of the timebuckets by. (Postgres type: "INTERVAL")
  - `:origin` - The timestamp used to align all of the time buckets. (Postgres type: "TIMESTAMP")

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/time_bucket/)
  """
  defmacro time_bucket(field, time_bucket, optional_args \\ []) do
    dynamic_function_fragment(:time_bucket, [time_bucket, field], optional_args, [
      :offset,
      :origin
    ])
  end

  @doc """
  Works similar to `time_bucket/2` but also activates gap-filling for the interval inferred
  by the where clause of the query.

  [Documentation](https://docs.timescale.com/api/latest/hyperfunctions/gapfilling-interpolation/time_bucket_gapfill/)
  """
  defmacro time_bucket_gapfill(field, time_bucket) do
    # quote do
    #   fragment("time_bucket_gapfill(?, ?)", unquote(time_bucket), unquote(field))
    # end

    dynamic_function_fragment(:time_bucket, [time_bucket, field], [], [])
  end
end
