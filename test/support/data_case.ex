defmodule Timescale.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias TimescaleApp.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Timescale.DataCase
    end
  end

  setup tags do
    Timescale.DataCase.setup_sandbox(tags)
    :ok
  end

  def setup_sandbox(tags) do
    repo_pid = Ecto.Adapters.SQL.Sandbox.start_owner!(TimescaleApp.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(repo_pid) end)
  end
end
