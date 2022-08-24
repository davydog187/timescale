defmodule Timescale.QueryUtils do
  @moduledoc false

  alias Timescale.OptionalArgError

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
          optional_args :: keyword(),
          supported_args :: list(atom())
        ) :: Macro.t()
  def dynamic_function_fragment(function_name, required_args, optional_args, supported_args) do
    # Validate the provided optional arguments
    validate_optional_args(function_name, optional_args, supported_args)

    # Put together the part of the fragment related to the optional arguments using named notation
    optional_arg_fragment =
      Enum.map(optional_args, fn {named_argument, _value} ->
        "#{named_argument} => ?"
      end)

    # Create the place holders for the required arguments and append the optional arguments
    fragment_interpolations =
      required_args
      |> Enum.map(fn _ -> "?" end)
      |> Kernel.++(optional_arg_fragment)
      |> Enum.join(", ")

    # Put together the TimescaleDB fragment call
    fragment_definition = "#{function_name}(#{fragment_interpolations})"

    # Extract the values for the optional arguments
    optional_arg_values = Enum.map(optional_args, fn {_arg, value} -> value end)

    quote do
      fragment(
        unquote(fragment_definition),
        unquote_splicing(required_args),
        unquote_splicing(optional_arg_values)
      )
    end
  end

  defp validate_optional_args(function_name, optional_args, supported_args) do
    remaining_invalid_keys = Keyword.keys(optional_args) -- supported_args

    if remaining_invalid_keys == [] do
      :ok
    else
      raise OptionalArgError, function: function_name, invalid_args: remaining_invalid_keys
    end
  end
end
