defmodule TimescaleApp.TZTable do
  use Ecto.Schema

  @primary_key false
  schema "tz_hypertable" do
    field(:timestamp, :utc_datetime_usec)
    field(:field, :float)
  end
end
