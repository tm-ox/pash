defmodule PashWeb.Custom.ButtonComponent do
  use Phoenix.Component
  use Gettext, backend: PashWeb.Gettext
  use PashWeb, :verified_routes

  # alias Phoenix.LiveView.JS

  attr(:label, :string, required: true, doc: "Button label")

  attr(:color, :atom,
    default: :default,
    values: ~w(default)a,
    doc: "Button color"
  )

  def btn(assigns) do
    ~H"""
    <button class={[
      color(@color),
      "inline-flex items-center px-2.5 py-1.5 w-fit",
      "text-xs font-medium",
      "border border-transparent rounded shadow-sm",
      "focus:outline-none focus:ring-2 focus:ring-offset-2"
    ]}>
      {@label}
    </button>
    """
  end

  defp color(:default), do: "bg-primary hover:bg-accent text-text focus:ring-accent"
end
