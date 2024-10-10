defmodule Correttezza.Boundary.PnetValidator do
  import Correttezza.Boundary.Validator

  def errors(fields) when is_map(fields) do
    []
    |> require(fields, :name, &validate_name/1)
    |> optional(fields, :positions, &validate_positions/1)
  end

  def errors(_fields), do: [{nil, "A map of fields is required"}]

  def validate_name(name) when is_binary(name) do
    check(String.match?(name, ~r{\S}), {:error, "can't be blank"})
  end

  def validate_name(_name), do: {:error, "must be a string"}

  def validate_positions(positions) when is_list(positions) do
    check(
      Enum.all?(
        positions,
        fn {pos_name, pos_mark} -> is_atom(pos_name) && pos_mark >= 0 end
      ),
      {:error, "must be list of {:atom, not_neg_number}"}
    )
  end

  def validate_positions(_positions), do: {:error, "must be a list"}
end
