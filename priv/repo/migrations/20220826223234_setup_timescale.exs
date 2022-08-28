defmodule TimescaleApp.Repo.Migrations.SetupTimescale do
  use Ecto.Migration

  import Timescale.Migration

  def change do
    create_timescaledb_extension()
  end
end
