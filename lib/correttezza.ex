defmodule Correttezza do
  alias Correttezza.Boundary.{PnetSession, PnetServer, PnetValidator}

  def add_conveyor(fields) do
    with :ok <- PnetValidator.errors(fields),
         :ok <- PnetServer.add_pnet(fields),
         do: :ok,
         else: (error -> error)
  end

  def lookup_conveyor_by_name(pname) do
    PnetServer.lookup_pnet_by_name(pname)
  end

  def get_conveyors() do
    PnetServer.get_state()
  end

  def start_task(conv_name, marking, context, task_id \\ Nanoid.generate()) do
    with task <- PnetServer.build_task(conv_name, marking, context, task_id),
         {:ok, pntask} <- GenServer.start_link(PnetSession, task) do
      pntask
    else
      error -> error
    end
  end
end
