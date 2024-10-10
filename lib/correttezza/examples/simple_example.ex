defmodule Correttezza.Examples.SimpleExample do
  def pnet_fields do
    positions = [
      p1: %{species: :input},
      p2: %{species: :internal},
      p3: %{
        species: :reqresp,
        params: [service: "http", url: "http://google.com", params: [search: :var1]]
      },
      p4: %{species: :final}
    ]

    transitions = [
      %{
        name: :t1,
        entry_positions: [p1: 2, p2: 1],
        exit_positions: [p3: 2],
        action: %{func: :func_add, args: [:var2, :var3], res: :var3}
      },
      %{
        name: :t2,
        entry_positions: [p2: 1, p3: 1],
        exit_positions: [p3: 1, p4: 1],
        action: %{func: :func_substr, args: [:var1, :var2], res: :var1}
      }
    ]

    context_schema = [
      var1: %{species: "integer", default: 10},
      var2: %{species: "integer", default: 100},
      var3: %{species: "integer"}
    ]

    %{
      name: "Simple3",
      positions: positions,
      transitions: transitions,
      context_schema: context_schema
    }
  end
end
