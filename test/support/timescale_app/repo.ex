defmodule TimescaleApp.Repo do
  use Ecto.Repo,
    otp_app: :timescale,
    adapter: Ecto.Adapters.Postgres
end
