defmodule TimescaleApp.Table do
  use Ecto.Schema

  @primary_key false
  schema "test_hypertable" do
    field(:timestamp, :naive_datetime_usec)
    field(:field, :float)

    field(:candlestick, :float)

    field(:price, :float)
    field(:volume, :float)
    field(:open, :float)
    field(:close, :float)
    field(:high, :float)
    field(:low, :float)
  end
end
