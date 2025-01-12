defmodule PashWeb.Custom.CardComponent do
  use Phoenix.Component
  use PashWeb, :verified_routes

  use Gettext,
    backend: PashWeb.Gettext

  @moduledoc """
  Card component module.
  """
  attr :image, :string, required: true, doc: "card image"
  attr :image_alt, :string, required: true, doc: "card image alt"

  attr :description, :string, required: true, doc: "card description, used as information"
  attr :description_title, :string, required: true, doc: "card description"

  attr :actions, :list,
    default: [],
    doc: "cards actions, such as `add to favourite`, `dislike`, `share` etc."

  attr :link, :string, default: "", doc: "card link"

  @spec card(Plug.Conn.t()) :: Phoenix.LiveView.Rendered.t()
  def card(assigns) do
    ~H"""
    <.link
      navigate={@link}
      class="shadow-basecontent/10 ring-basecontent/10 rounded-2xl bg-base px-4 py-8 shadow-lg space-y-4"
    >
      <img class="object-cover rounded-lg rounded-b-sm" src={@image} alt={@image_alt} />
      <div class="space-y-1">
        <h4>{@description_title}</h4>
        <p>{@description}</p>
      </div>
      <div class="card__actions">
        <h5>Actions</h5>
        <div class="card__actions-links">
          <p :for={action <- @actions}>
            <.display_icon name={action.name} href={action.href} />
          </p>
        </div>
      </div>
    </.link>
    """
  end

  attr :name, :string, required: false, doc: "action name"
  attr :href, :string, required: false, doc: "action link"

  # @spec display_icon(Plug.Conn.t() :: Phoenix.LiveView.Rendered.t()
  defp display_icon(%{name: "love"} = assigns) do
    ~H"""
    <a href={@href}><i class="fa fa-heart fa-2x" /></a>
    """
  end

  defp display_icon(%{name: "dislike"} = assigns) do
    ~H"""
    <a href={@href}><i class="fa fa-thumbs-down fa-2x" /></a>
    """
  end
end
