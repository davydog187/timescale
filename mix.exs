defmodule Timescale.MixProject do
  use Mix.Project

  @repo_url "https://github.com/bitfo/timescale"

  def project do
    [
      app: :timescale,
      version: "0.0.1-alpha.1",
      elixir: "~> 1.11",
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
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end
end
