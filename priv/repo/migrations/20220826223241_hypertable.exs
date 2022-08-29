defmodule TimescaleApp.Repo.Migrations.Hypertable do
  use Ecto.Migration

  import Timescale.Migration

  def change do
    create table(:test_hypertable, primary_key: false) do
      add :timestamp, :naive_datetime_usec, null: false
      add :field, :float, null: false
    end

    create_hypertable(:test_hypertable, :timestamp)
    enable_hypertable_compression(:test_hypertable, segment_by: :timestamp)
    add_compression_policy(:test_hypertable, "60d")
  end
end
