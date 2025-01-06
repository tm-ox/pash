defmodule PashWeb.NavComponent do
  @moduledoc false

  use Phoenix.Component
  use Gettext, backend: PashWeb.Gettext

  import PashWeb.CoreComponents, only: [icon: 1]
  alias Phoenix.LiveView.JS

  attr :id, :string, default: "navbar"
  attr :tabs, :list, required: true
  attr :active_tab, :atom, required: true
  slot :brand_block, doc: "brand"

  def navbar(assigns) do
    ~H"""
    <nav class="flex items-center py-4 w-full h-fit">
      {render_slot(@brand_block)}
      <.link
        class="flex gap-2 items-center ml-auto text-accent hover:text-primary"
        phx-click={show_navbar(@id)}
      >
        <h5>Menu</h5>
        <.icon name="hero-bars-3" class="w-6 h-6" />
      </.link>
    </nav>
    <div
      id={"#{@id}-bg"}
      class="fixed inset-0 bg-background/20 backdrop-blur transition-opacity hidden z-10"
      aria-hidden="true"
      phx-click={hide_navbar(@id)}
    />
    <div
      id={"#{@id}-container"}
      class="fixed inset-y-0 right-0 px-4 lg:px-0 lg:right-12 w-full lg:w-80 hidden z-10 box-border"
    >
      <div class="flex flex-col py-16 h-full">
        <div class="absolute top-2">
          <.close_button id={@id} click={hide_navbar(@id)} />
        </div>
        <div class="absolute top-4 right-4 lg:right-0 flex items-center">
          <.theme id="theme" />
        </div>
        <aside
          id={@id}
          class="flex flex-1 flex-col overflow-y-auto border border-primary rounded h-fit"
        >
          <.sidebar_nav active_tab={@active_tab} tabs={@tabs} />
        </aside>
      </div>
    </div>
    """
  end

  attr :id, :string, default: "sidebar"
  attr :tabs, :list, required: true
  attr :active_tab, :atom, required: true
  slot :brand_block, doc: "brand"

  def sidebar(assigns) do
    ~H"""
    <header class="flex p-4 lg:hidden">
      <.link class="mr-4" phx-click={show_sidebar(@id)}>
        <.icon name="hero-bars-3" class="w-6 h-6 text-primary hover:text-accent" />
      </.link>
      {render_slot(@brand_block)}
    </header>
    <div
      id={"#{@id}-bg"}
      class="fixed inset-0 bg-black/20 backdrop-blur transition-opacity hidden z-10"
      aria-hidden="true"
      phx-click={hide_sidebar(@id)}
    />
    <div
      id={"#{@id}-container"}
      class="fixed inset-y-0 left-0 w-60 h-full max-lg:hidden z-10 border border-primary"
    >
      <div class="flex min-h-0 flex-col">
        <aside id={@id} class="flex flex-1 flex-col h-full overflow-y-auto">
          <div class="absolute top-2 right-5 lg:hidden">
            <.close_button id={@id} click={hide_sidebar(@id)} />
          </div>
          <div class="flex gap-4 justify-between px-3 py-4 border-b border-primary">
            {render_slot(@brand_block)}
          </div>
          <.sidebar_nav active_tab={@active_tab} tabs={@tabs} />
          <div class="flex flex-grow w-full py-4 bg-background border-b border-primary justify-center">
            <.theme id="theme" />
          </div>
        </aside>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :click, :string, default: nil

  defp close_button(assigns) do
    ~H"""
    <button
      id={"close-sidebar-btn-" <> @id}
      phx-click={@click}
      type="button"
      class="mt-2 flex-none text-primary hover:text-accent"
      aria-label={gettext("Cerrar")}
    >
      <.icon name="hero-x-mark-solid" class="w-6 h-6" />
    </button>
    """
  end

  defp theme(assigns) do
    ~H"""
    <div>
      <button
        phx-click={JS.dispatch("toogle-theme")}
        class="theme-button text-primary hover:text-accent mt-1"
        aria-label="Toggle theme"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 20 20">
          <path
            fill="currentColor"
            d="M10 3.5a6.5 6.5 0 1 1 0 13zM10 2a8 8 0 1 0 0 16a8 8 0 0 0 0-16"
          />
        </svg>
      </button>
    </div>
    """
  end

  attr :tabs, :list, required: true
  attr :active_tab, :atom, required: true

  defp sidebar_nav(assigns) do
    ~H"""
    <div class="flex flex-col h-full">
      <.sidebar_menu_item :for={item <- @tabs} active_tab={@active_tab} item={item} />
    </div>
    """
  end

  attr :item, :map, required: true
  attr :active_tab, :atom, default: nil

  defp sidebar_menu_item(assigns) do
    assigns =
      assigns
      |> assign_new(:toggle, fn -> has_tabs?(assigns.item) end)
      |> assign_new(:show_group, fn -> should_show_group?(assigns.item, assigns.active_tab) end)

    ~H"""
    <.sidebar_link item={@item} active_tab={@active_tab} toggle={@toggle} />

    <.sidebar_group :if={@toggle} tab={@item.tab} show_group={@show_group}>
      <.sidebar_menu_item :for={item <- @item.tabs} item={item} active_tab={@active_tab} />
    </.sidebar_group>

    <div :if={@item[:separator]} class="py-2">
      <div class="border-b"></div>
    </div>
    """
  end

  attr :item, :map, required: true
  attr :active_tab, :atom, default: nil
  attr :toggle, :boolean, required: true

  defp sidebar_link(assigns) do
    assigns =
      assigns
      |> assign_new(:active, fn -> active_tab?(assigns.item, assigns.active_tab) end)
      |> assign_new(:toggle_options, fn -> build_toggle_options(assigns.toggle, assigns.item) end)
      |> assign_new(:rest, fn -> assigns.item[:options] || [] end)

    ~H"""
    <div class={[
      "flex tabs-center px-1 py-2 text-primary border-b border-primary hover:border-b hover:border-accent hover:text-accent bg-background",
      @active && "!text-accent border-b !border-accent"
    ]}>
      <.link
        class="w-full p-2 flex items-center whitespace-nowrap space-x-2"
        {@toggle_options}
        {@rest}
      >
        <.icon :if={@item[:icon]} name={@item.icon} class="h-5 w-5" />
        <div class="flex-1">{@item.label}</div>
        <div :if={@item[:badge]} class="justify-end text-center rounded border min-w-6 px-2">
          {@item[:badge]}
        </div>
        <div :if={@toggle} class="justify-end text-center min-w-6">
          <.icon name="hero-chevron-down" class="h-4 w-4" />
        </div>
      </.link>
    </div>
    """
  end

  attr :show_group, :boolean, required: true
  attr :tab, :atom, required: true
  slot :inner_block

  defp sidebar_group(assigns) do
    ~H"""
    <ul id={"sidebar-parent-#{@tab}"} class={["ml-7 pl-0", !@show_group && "hidden"]}>
      {render_slot(@inner_block)}
    </ul>
    """
  end

  defp show_navbar(id) when is_binary(id) do
    %JS{}
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "##{id}-container",
      transition:
        {"transition-all transform ease-out duration-100", "translate-x-72", "translate-x-0"}
    )
    |> JS.add_class("overflow-hidden", to: "body")
  end

  defp hide_navbar(id) when is_binary(id) do
    %JS{}
    |> JS.hide(
      to: "##{id}-container",
      transition:
        {"transition-all transform ease-out duration-100", "translate-x-0", "translate-x-72"}
    )
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  defp show_sidebar(id) when is_binary(id) do
    %JS{}
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "##{id}-container",
      transition:
        {"transition-all transform ease-out duration-100", "-translate-x-72", "translate-x-0"}
    )
    |> JS.add_class("overflow-hidden", to: "body")
  end

  defp hide_sidebar(id) when is_binary(id) do
    %JS{}
    |> JS.hide(
      to: "##{id}-container",
      transition:
        {"transition-all transform ease-out duration-100", "translate-x-0", "-translate-x-72"}
    )
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  defp toggle_group(tab) do
    JS.toggle(%JS{}, to: "#sidebar-parent-#{tab}")
  end

  defp has_tabs?(item) do
    item[:tabs] && !Enum.empty?(item.tabs)
  end

  defp should_show_group?(item, active_tab) do
    tabs = item[:tabs] || []

    tabs
    |> Enum.map(&Map.put(&1, :parent, item[:tab]))
    |> Enum.any?(fn %{parent: parent, tab: tab} ->
      parent == active_tab || tab == active_tab
    end)
  end

  defp active_tab?(item, active_tab) do
    item[:tab] && active_tab && item.tab == active_tab
  end

  defp build_toggle_options(toggle, item) do
    if toggle, do: ["phx-click": toggle_group(item.tab)], else: []
  end
end
