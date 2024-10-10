defmodule Correttezza.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting Correttezza")

    children = [
      {Correttezza.Boundary.PnetServer, [name: Correttezza.Boundary.PnetServer]},
      {Registry, [name: Correttezza.Registry.PnetSession, keys: :unique]},
      {DynamicSupervisor, [name: Correttezza.Supervisor.PnetSession, strategy: :one_for_one]}
    ]

    opts = [strategy: :one_for_one, name: Correttezza.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
