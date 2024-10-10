defmodule Correttezza.Core.PnetDescr do
  require Logger

  alias Correttezza.Core.Transition

  @enforce_keys [:name, :positions, :transitions]
  defstruct ~w[conv_id name positions transitions cont_schema]a

  #  def new(%{name: n, positions: p, transitions: t, context_schema: cs}) do
  def new(fields) do
    IO.puts("Name: #{fields.name}")

    %__MODULE__{
      conv_id: Nanoid.generate(),
      name: fields.name,
      positions: fields.positions,
      transitions: Enum.map(fields.transitions, fn tr -> struct(Transition, tr) end),
      cont_schema: fields.context_schema
    }
  end
end
