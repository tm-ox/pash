defmodule PashWeb.Custom.ListComponent do
  use Phoenix.Component
  # alias Phoenix.LiveView.JS

  use Gettext,
    backend: PashWeb.Gettext

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-accent">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-primary">{item.title}</dt>
          <dd class="text-basecontent">{render_slot(item)}</dd>
        </div>
      </dl>
    </div>
    """
  end
end
