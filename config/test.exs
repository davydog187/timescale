import Config

config :timescale, :ecto_repos, [TimescaleApp.Repo]

config :timescale, TimescaleApp.Repo,
  database: "timescale_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
