defmodule TimescaleApp.Table do
  use Ecto.Schema

  @primary_key false
  schema "my_table" do
    field(:a, :string)
    field(:b, :string)
    field(:timestamp, :naive_datetime)
  end
end
