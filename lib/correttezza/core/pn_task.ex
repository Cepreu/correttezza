defmodule Correttezza.Core.PnTask do
  require Logger

  alias Correttezza.Core.{PnetDescr, Transition}

  defstruct ~w[task_id conveyor marking context]a

  def new(
        conveyor = %PnetDescr{},
        task_id,
        marking,
        context
      ) do
    %__MODULE__{
      task_id: task_id,
      conveyor: conveyor,
      marking: marking,
      context: context
    }
  end

  def run(pn = %__MODULE__{}) do
    IO.inspect(pn.marking, label: "--->")
    IO.inspect(pn.context, label: "Context")

    case finished(pn) do
      nil ->
        case runnable(pn) do
          nil -> {:waiting, pn}
          tr -> run(Transition.fire(tr, pn))
        end

      _ ->
        {:finished, pn}
    end
  end

  defp finished(pn = %__MODULE__{}) do
    Enum.find(pn.conveyor.positions, fn {k, v} ->
      Keyword.get(pn.marking, k) > 0 && v.type == :final
    end)
  end

  defp runnable(pn = %__MODULE__{}) do
    Enum.find(pn.conveyor.transitions, fn tr -> Transition.runnable(pn.marking, tr) end)
  end
end
