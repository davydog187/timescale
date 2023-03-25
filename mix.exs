defmodule Timescale.MixProject do
  use Mix.Project

  @repo_url "https://github.com/davydog187/timescale"
  @version "0.1.0"

  def project do
    [
      aliases: aliases(),
      app: :timescale,
      version: @version,
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Timescale",
      source_url: @repo_url,
      homepage_url: @repo_url,
      description: "Easy time-series data in TimescaleDB with Ecto",
      package: package(),
      docs: docs()
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths(:dev) ++ ["test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def package do
    [
      licenses: ["Apache-2.0"],
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      links: %{
        "GitHub" => @repo_url
      }
    ]
  end

  def docs do
    [
      # The main page in the docs
      api_reference: false,
      main: "Timescale",
      source_url: @repo_url,
      source_ref: "v#{@version}",
      extra_section: "GUIDES",
      extras: [
        "guides/intro.livemd"
      ]
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
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.8"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:postgrex, "~> 0.16.4", only: :test}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
