defmodule Timescale.QueryUtils do
  @moduledoc false

  @doc """
  This function generates a dynamic fragment based upon the optional
  arguments that are provided. If no optional arguments are provided,
  only the required arguments are passed to the TimescaleDB function
  fragment.

  For example, calling `Timescale.Hyperfunctions.time_bucket/3` with optional
  arguments would yield something like so:

  ```elixir
  from(
    t in Table,
    select: time_bucket(t.timestamp, "5 minutes", origin: "1900-01-01", timezone: "Europe/Athens")
  )

  Would yield the following SQL query:

  ```
  SELECT time_bucket('5 minutes', m0."timestamp", origin => '1900-01-01', timezone => 'Europe/Athens') FROM "my_table" AS m0
  ```
  """
  @spec dynamic_function_fragment(
          function_name :: atom(),
          required_args :: list(),
          optional_arg :: keyword()
        ) :: Macro.t()
  def dynamic_function_fragment(function_name, required_args, optional_args) do
    # TODO: Perhaps we also match on: `{named_argument, {_value, type}}`
    # and provide type casts since the Timescale docs provide the types for
    # the optional args?
    optional_arg_fragment =
      Enum.map(optional_args, fn {named_argument, _value} ->
        "#{named_argument} => ?"
      end)

    fragment_interpolations =
      required_args
      |> Enum.map(fn _ -> "?" end)
      |> Kernel.++(optional_arg_fragment)
      |> Enum.join(", ")

    fragment_definition = "#{function_name}(#{fragment_interpolations})"

    optional_arg_values = Enum.map(optional_args, fn {_arg, value} -> value end)

    quote do
      fragment(
        unquote(fragment_definition),
        unquote_splicing(required_args),
        unquote_splicing(optional_arg_values)
      )
    end
  end
end
