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
end
