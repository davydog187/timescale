defmodule TimescaleApp.Repo.Migrations.TimezoneTable do
  use Ecto.Migration

  import Timescale.Migration

  def change do
    create table(:tz_hypertable, primary_key: false) do
      add :timestamp, :utc_datetime_usec, null: false
      add :field, :float, null: false
    end

    create_hypertable(:tz_hypertable, :timestamp)
  end
end
