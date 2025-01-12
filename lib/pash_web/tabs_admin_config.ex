defmodule PashWeb.TabsAdminConfig do
  @moduledoc false

  use PashWeb, :verified_routes
  use Gettext, backend: PashWeb.Gettext

  def view_admin_groups do
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

  def tabs_admin_config do
    [
      %{
        label: gettext("Admin"),
        icon: "hero-user-solid",
        tab: :admin,
        options: [navigate: ~p"/admin"]
        # separator: true
        # badge: 1
      },
      %{
        label: gettext("Blog"),
        icon: "hero-paper-clip",
        tab: :blog,
        options: %{navigate: ~p"/blog/manage"}
        # separator: true
        # badge: 1
      }
    ]
  end
end
