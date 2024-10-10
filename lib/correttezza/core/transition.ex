defmodule Correttezza.Core.Transition do
  alias Correttezza.Core.{PnTask, Functions}

  defstruct(
    name: nil,
    entry_positions: [],
    exit_positions: [],
    action: &Functions.tr_idle/1
  )

  def runnable(positions, tr = %__MODULE__{}) do
    Enum.all?(tr.entry_positions, fn
      {k, v} -> !!(positions[k] && positions[k] >= v)
    end)
  end

  def fire(t, pn = %PnTask{}) do
    IO.inspect(t, label: "transition")

    new_context =
      Functions.apply(pn.context, t.action)

    new_pn = %{
      pn
      | marking:
          Enum.map(
            pn.marking,
            fn {k, v} ->
              cond do
                !!t.entry_positions[k] -> {k, v - t.entry_positions[k]}
                !!t.exit_positions[k] -> {k, v + t.exit_positions[k]}
                true -> {k, v}
              end
            end
          ),
        context: new_context
    }

    new_pn
  end
end
