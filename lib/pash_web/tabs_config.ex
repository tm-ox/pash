defmodule PashWeb.TabsConfig do
  @moduledoc false

  use PashWeb, :verified_routes
  use Gettext, backend: PashWeb.Gettext

  def view_groups do
    %{
      home: [PashWeb.HomeLive],
      blog: [PashWeb.PostLive],
      admin: [PashWeb.AdminLive]
      # products: [PashWeb.ProductLive.Index, PashWeb.ProductLive.Show],
      # stock: [PashWeb.StockLive],
      # clients: [PashWeb.ClientLive],
      # account: [PashWeb.AccountLive],
      # notifications: [PashWeb.NotificationLive]
    }
  end

  def tabs_config do
    [
      %{
        label: gettext("Home"),
        icon: "hero-home-solid",
        tab: :home,
        options: [navigate: ~p"/"]
      },
      %{
        label: gettext("Blog"),
        icon: "hero-paper-clip",
        tab: :home,
        options: [navigate: ~p"/blog"]
      },
      # %{
      #   label: gettext("Blog"),
      #   icon: "hero-paper-clip",
      #   tab: :blog,
      #   tabs: [
      #     %{
      #       label: gettext("View"),
      #       tab: :blog,
      #       options: [navigate: ~p"/blog"]
      #     },
      #     %{
      #       label: gettext("Edit"),
      #       tab: :edit,
      #       options: %{navigate: ~p"/blog/edit"}
      #     }
      #   ]
      # },
      %{
        label: gettext("Admin"),
        icon: "hero-user-solid",
        tab: :admin,
        options: [navigate: ~p"/sign-in"]
        # separator: true
        # badge: 1
      }
    ]
  end
end
