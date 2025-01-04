defmodule PashWeb.PostLive.Show do
  use PashWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- <.header>
      Post {@post.id}
      <:subtitle>This is a post record from your database.</:subtitle>

      <:actions> --%>
    <.link patch={~p"/blog/#{@post}/show/edit"} phx-click={JS.push_focus()}>
      <.button>Edit post</.button>
    </.link>
    <%!-- </:actions>
    </.header> --%>

    <.list>
      <:item title="Id">{@post.id}</:item>
      <:item title="Content">{@post.content}</:item>
    </.list>

    <.back navigate={~p"/blog"}>Back to posts</.back>

    <.modal :if={@live_action == :edit} id="post-modal" show on_cancel={JS.patch(~p"/blog/#{@post}")}>
      <.live_component
        module={PashWeb.PostLive.FormComponent}
        id={@post.id}
        title={@page_title}
        action={@live_action}
        post={@post}
        patch={~p"/blog/#{@post}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, Ash.get!(Pash.Blog.Post, id))}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
