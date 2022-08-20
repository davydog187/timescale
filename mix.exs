defmodule Timescale.MixProject do
  use Mix.Project

  @repo_url "https://github.com/bitfo/timescale"

  def project do
    [
      app: :timescale,
      version: "0.0.1-alpha.2",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Timescale",
      source_url: @repo_url,
      homepage_url: @repo_url,
      description: "Easy time-series data in TimescaleDB with Ecto",
      package: package(),
      docs: [
        # The main page in the docs
        main: "Timescale"
      ]
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths(:dev) ++ ["test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def package do
    [
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => @repo_url
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.8", only: :test},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:postgrex, "~> 0.16.4", only: :test}
    ]
  end
end
