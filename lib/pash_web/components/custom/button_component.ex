defmodule PashWeb.Custom.ButtonComponent do
  use Phoenix.Component
  # alias Phoenix.LiveView.JS

  use Gettext,
    backend: PashWeb.Gettext

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded bg-primary hover:bg-accent py-1 px-3",
        "text-sm font-semibold leading-6 text-primarycontent active:text-primarycontent/80",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end
end
