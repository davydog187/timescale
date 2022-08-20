defmodule Timescale.SQLCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Timescale.Test.Helpers
    end
  end
end
