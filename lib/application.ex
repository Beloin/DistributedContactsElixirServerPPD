defmodule DistributedServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {DistributedServer, 9001}
      # Starts a worker by calling: TcpServer.Worker.start_link(arg)
      # {TcpServer.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DistributedServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
