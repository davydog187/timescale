defmodule Timescale.Test.Helpers do
  defmacro assert_sql(left, right) do
    quote bind_quoted: [left: left, right: right] do
      assert Timescale.Test.Helpers.to_sql(left) == Timescale.Test.Helpers.to_sql(right)
    end
  end

  def to_sql(query) when is_binary(query), do: query

  def to_sql(query) do
    {sql, _} = Ecto.Adapters.SQL.to_sql(:all, TimescaleApp.Repo, query)
    sql
  end
end
