defmodule PashWeb.AdminLive.Index do
  use PashWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, page_title: "Admin")
    {:ok, socket, layout: {PashWeb.Layouts, :admin}}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Admin</h1>
    """
  end
end
