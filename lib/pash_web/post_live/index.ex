defmodule PashWeb.PostLive.Index do
  use PashWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Blog</h1>
    <div class="col-layout">
      <%= for {_id, post} <- @streams.blog do %>
        <.card
          image={post.image_url}
          image_alt={post.image_alt}
          description={post.content}
          description_title={post.title}
        />
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :blog, Ash.read!(Pash.Blog.Post))}
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Post")
  #   |> assign(:post, Ash.get!(Pash.Blog.Post, id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Post")
  #   |> assign(:post, nil)
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing blog")
  #   |> assign(:post, nil)
  # end

  # @impl true
  # def handle_info({PashWeb.PostLive.FormComponent, {:saved, post}}, socket) do
  #   {:noreply, stream_insert(socket, :blog, post)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   post = Ash.get!(Pash.Blog.Post, id)
  #   Ash.destroy!(post)

  #   {:noreply, stream_delete(socket, :blog, post)}
  # end
end
