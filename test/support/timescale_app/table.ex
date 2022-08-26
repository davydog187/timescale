defmodule TimescaleApp.Table do
  use Ecto.Schema

  @primary_key false
  schema "test_hypertable" do
    field(:timestamp, :naive_datetime_usec)
    field(:field, :float)
  end
end
