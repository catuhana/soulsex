defmodule Soulsex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Soulsex.Repo,
      Soulsex.Connection.Registry,
      :ranch.child_spec(
        :soulsex,
        :ranch_tcp,
        %{
          socket_opts: [
            port: port(),
            keepalive: true
          ]
        },
        Soulsex.Connection,
        []
      )
    ]

    opts = [strategy: :one_for_one, name: Soulsex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port, do: Application.get_env(:soulsex, :port, 2242)
end
