defmodule Correttezza.Boundary.PnetSession do
  alias Correttezza.Core.{PnTask}
  use GenServer

  def child_spec(pntask = %PnTask{}) do
    %{
      id: {__MODULE__, {pntask.conveyor.conv_id, pntask.task_id}},
      start: {__MODULE__, :start_link, [pntask]},
      restart: :temporary
    }
  end

  def start_link(pntask) do
    GenServer.start_link(
      __MODULE__,
      pntask,
      name: via({pntask.conveyor.conv_id, pntask.task_id})
    )
  end

  def start_pnet(pntask) do
    DynamicSupervisor.start_child(
      Correttezza.Supervisor.PnetSession,
      {__MODULE__, pntask}
    )
  end

  #### PnetSession Callbacks
  def init(pntask) do
    {:ok, pntask}
  end

  def handle_call(:get_state, _from, pntask) do
    {:reply, pntask, pntask}
  end

  def handle_call({:update_task, markup_override, context_override}, _from, pntask) do
    new_pntask = %{pntask | positions: Keyword.merge(pntask.positions, markup_override)}

    new_pntask = Keyword.merge(new_pntask.context, context_override)

    {:reply, :ok, new_pntask}
  end

  def handle_call(:run_task, _from, pntask) do
    {status, new_pntask} = PnTask.run(pntask)

    case status do
      :waiting -> {:reply, new_pntask, new_pntask}
      :finished -> {:stop, :normal, :finished, nil}
    end
  end

  ##########
  def update_net(name, markup_override \\ [], context_override \\ []) do
    GenServer.call(via(name), {:update_task, markup_override, context_override})
  end

  def run_pnet(name) do
    GenServer.call(via(name), :run_task)
  end

  def via({_conv_id, pntask_id}) do
    {
      :via,
      Registry,
      {Correttezza.Registry.PnetSession, pntask_id}
    }
  end
end
