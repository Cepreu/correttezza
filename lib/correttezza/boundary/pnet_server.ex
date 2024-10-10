defmodule Correttezza.Boundary.PnetServer do
  use GenServer
  require Logger
  alias Correttezza.Core.{PnetDescr, PnTask}

  def init(pnets) when is_map(pnets) do
    {:ok, pnets}
  end

  def init(_pnets), do: {:error, "pnets must be a map"}

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options)
  end

  def handle_call(:get_state, _from, pnets) do
    {:reply, Enum.map(pnets, fn {name, pname} -> {name, pname.conv_id} end), pnets}
  end

  def handle_call({:pnet_add, fields}, _from, pnets) do
    pn = PnetDescr.new(fields)
    IO.puts("Inserting the net: #{inspect(pn)}")
    {:reply, :ok, Map.put(pnets, pn.name, pn)}
  end

  def handle_call({:pnet_build_task, conv_name, marking, context, task_id}, _from, pnets) do
    conveyor = Map.get(pnets, conv_name)
    IO.puts("Building the net: #{inspect({conv_name, marking, context, task_id})}")
    {:reply, PnTask.new(conveyor, task_id, marking, context), pnets}
  end

  def handle_call({:lookup_pnet_by_name, pnet_name}, _from, pnets) do
    {:reply, pnets[pnet_name], pnets}
  end

  def terminate(reason, _state) do
    IO.puts("Terminating with reason #{reason}")
  end

  ### API ####
  @spec add_pnet(atom() | pid() | {atom(), any()} | {:via, atom(), any()}, any()) :: any()
  def add_pnet(pnserver \\ __MODULE__, pnet_fields) do
    GenServer.call(pnserver, {:pnet_add, pnet_fields})
  end

  def lookup_pnet_by_name(pnserver \\ __MODULE__, pnet_name) do
    GenServer.call(pnserver, {:lookup_pnet_by_name, pnet_name})
  end

  def build_task(pnserver \\ __MODULE__, conv_name, marking, context, task_id) do
    GenServer.call(pnserver, {:pnet_build_task, conv_name, marking, context, task_id})
  end

  def get_state(pnserver \\ __MODULE__) do
    GenServer.call(pnserver, :get_state)
  end
end
