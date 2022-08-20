defmodule Timescale do
  @external_resource "README.md"
  @moduledoc File.read!("README.md")
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)
end
