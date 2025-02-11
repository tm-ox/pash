defmodule Pash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PashWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:pash, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pash.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pash.Finch},
      # Start a worker by calling: Pash.Worker.start_link(arg)
      # {Pash.Worker, arg},
      # Start to serve requests, typically the last entry
      PashWeb.Endpoint,
      Pash.Repo,
      {AshAuthentication.Supervisor, [otp_app: :pash]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PashWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
