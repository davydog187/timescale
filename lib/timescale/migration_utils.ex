defmodule Timescale.MigrationUtils do
  @moduledoc false

  alias Timescale.MigrationArgError

  @doc """
  This function generates a dynamic select migration based upon the optional
  arguments that are provided. If no optional arguments are provided,
  only the required arguments are passed to the TimescaleDB function
  fragment.

  For example, calling `Timescale.Hyperfunctions.add_compression_policy/3` with optional
  arguments would yield something like so:

  ```elixir
  add_compression_policy(:my_ts_table, "10 hours", if_not_exists: true)
  ```

  Would yield the following Ecto query:

  ```
  Query: "SELECT add_compression_policy($1, $2, if_not_exists => $3)"
  Args: [:my_ts_table, "10 hours", true]
  ```
  """
  @spec select_migration(
          function_name :: atom(),
          required_args :: list(),
          optional_args :: keyword(),
          supported_args :: list(atom())
        ) :: Macro.t()
  def select_migration(function_name, required_args, optional_args, supported_args) do
    # Validate the provided optional arguments
    validate_optional_args(function_name, optional_args, supported_args)

    # Put together the part of the select migration related to the optional arguments using named notation
    optional_arg_placeholders =
      optional_args
      |> Enum.with_index(length(required_args) + 1)
      |> Enum.map(fn {{named_argument, _value}, index} ->
        "#{named_argument} => $#{index}"
      end)

    # Create the place holders for the required arguments and append the optional arguments
    all_function_args =
      required_args
      |> Enum.with_index(1)
      |> Enum.map(fn
        {{_, :text}, index} -> "$#{index}::TEXT"
        {_, index} -> "$#{index}"
      end)
      |> Kernel.++(optional_arg_placeholders)
      |> Enum.join(", ")

    # Put together the TimescaleDB select call
    select_query = "SELECT #{function_name}(#{all_function_args})"

    # Extract the values for the optional arguments
    required_args =
      Enum.map(required_args, fn
        {value, _type} -> value
        value -> value
      end)

    all_function_args = required_args ++ Enum.map(optional_args, fn {_arg, value} -> value end)

    quote do
      execute(fn ->
        repo().query!(unquote(select_query), unquote(all_function_args))
      end)
    end
  end

  @doc """
  Use this function to normalize input to migrations so that either atoms
  or strings can be provided for table and column names.
  """
  def normalize_arg(arg) when is_atom(arg), do: Atom.to_string(arg)
  def normalize_arg(arg), do: arg

  defp validate_optional_args(function_name, optional_args, supported_args) do
    remaining_invalid_keys = Keyword.keys(optional_args) -- supported_args

    if remaining_invalid_keys == [] do
      :ok
    else
      raise MigrationArgError, function: function_name, invalid_args: remaining_invalid_keys
    end
  end
end
