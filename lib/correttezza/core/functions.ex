defmodule Correttezza.Core.Functions do
  defstruct ~w[name category description return_type assignee args exceptions]a

  def apply(context, %{res: assignee, func: :func_add, args: [arg1, arg2]}) do
    arg1 = if is_atom(arg1), do: Keyword.get(context, arg1), else: arg1
    arg2 = if is_atom(arg2), do: Keyword.get(context, arg2), else: arg2
    IO.inspect(arg1, label: "arg1:")
    IO.inspect(arg2, label: "arg2:")

    Keyword.put(
      context,
      assignee,
      arg1 + arg2
    )
  end

  def apply(context, %{res: assignee, func: :func_substr, args: [arg1, arg2]}) do
    arg1 = if is_atom(arg1), do: Keyword.get(context, arg1), else: arg1
    arg2 = if is_atom(arg2), do: Keyword.get(context, arg2), else: arg2

    Keyword.put(
      context,
      assignee,
      arg1 - arg2
    )
  end

  def get_funtion(func_id) do
    %{tr_idle: &tr_idle/1, addition_int: &tr_add/3, substraction_int: &tr_substr/3}[func_id]
  end

  def tr_idle(context) do
    context
  end

  @spec tr_add(keyword(), atom(), atom()) :: [{atom(), any()}, ...]
  def tr_add(context, term1, term2) do
    Keyword.put(
      context,
      term1,
      Keyword.get(context, term1) + Keyword.get(context, term2)
    )
  end

  def tr_substr(context, minuend, subtrahend) do
    Keyword.put(
      context,
      minuend,
      Keyword.get(context, minuend) - Keyword.get(context, subtrahend)
    )
  end
end
