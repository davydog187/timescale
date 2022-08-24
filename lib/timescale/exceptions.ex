defmodule Timescale.OptionalArgError do
  @moduledoc """
  Raised at compilation time when the query contains operation TimescaleDB arguments
  that are not supported by the provided function.
  """

  defexception [:function, :invalid_args]

  @impl true
  def exception(opts) do
    function = Keyword.fetch!(opts, :function)
    invalid_args = Keyword.fetch!(opts, :invalid_args)

    %__MODULE__{function: function, invalid_args: invalid_args}
  end

  @impl true
  def message(%__MODULE__{function: function, invalid_args: invalid_args}) do
    "The #{function} TimescaleDB function does support the following options: #{inspect(invalid_args)}"
  end
end
