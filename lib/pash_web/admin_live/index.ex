defmodule PashWeb.AdminLive.Index do
  use PashWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Admin</h1>
    """
  end
end
