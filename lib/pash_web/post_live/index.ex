defmodule PashWeb.PostLive.Index do
  use PashWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <div class="flex gap-4">
        <%= for {_id, post} <- @streams.blog do %>
          <.card
            image={post.image_url}
            image_alt={post.image_alt}
            description={post.content}
            description_title={post.title}
          />
        <% end %>
      </div>
    </section>

    <section>
      <.header>
        Listing blog
        <:actions>
          <.link patch={~p"/blog/new"}>
            <.button>New Post</.button>
          </.link>
        </:actions>
      </.header>

      <.table
        id="blog"
        rows={@streams.blog}
        row_click={fn {_id, post} -> JS.navigate(~p"/blog/#{post}") end}
      >
        <:col :let={{_id, post}} label="Title">{post.title}</:col>
        <:col :let={{_id, post}} label="Image">
          <img class="h-8 w-8 object-contain" src={post.image_url} />
        </:col>
        <:col :let={{_id, post}} label="Image Alt">{post.image_alt}</:col>
        <:col :let={{_id, post}} label="Content">{post.content}</:col>

        <:action :let={{_id, post}}>
          <div class="sr-only">
            <.link navigate={~p"/blog/#{post}"}>Show</.link>
          </div>

          <.link patch={~p"/blog/#{post}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, post}}>
          <.link
            phx-click={JS.push("delete", value: %{id: post.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </section>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="post-modal"
      modal_show
      on_cancel={JS.patch(~p"/blog")}
    >
      <.live_component
        module={PashWeb.PostLive.FormComponent}
        id={(@post && @post.id) || :new}
        title={@page_title}
        action={@live_action}
        post={@post}
        patch={~p"/blog"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :blog, Ash.read!(Pash.Blog.Post))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Ash.get!(Pash.Blog.Post, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing blog")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({PashWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :blog, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Ash.get!(Pash.Blog.Post, id)
    Ash.destroy!(post)

    {:noreply, stream_delete(socket, :blog, post)}
  end
end
