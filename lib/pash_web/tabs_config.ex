defmodule PashWeb.TabsConfig do
  @moduledoc false

  use PashWeb, :verified_routes
  use Gettext, backend: PashWeb.Gettext

  def view_groups do
    %{
      home: [PashWeb.PageController],
      blog: [PashWeb.PostLive]
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
      # %{
      #   label: gettext("Blog"),
      #   icon: "hero-paper-clip",
      #   tab: :blog,
      #   options: [navigate: ~p"/blog"]
      # },
      # %{
      #   label: gettext("Storybook"),
      #   icon: "hero-book-open-solid",
      #   tab: :storybook,
      #   options: [navigate: ~p"/storybook"]
      # },
      %{
        label: gettext("Blog"),
        icon: "hero-paper-clip",
        tab: :inventory,
        tabs: [
          %{
            label: gettext("View"),
            tab: :blog,
            options: [navigate: ~p"/blog"]
          },
          %{
            label: gettext("Edit"),
            tab: :edit,
            options: %{navigate: ~p"/blog/edit"}
          }
        ]
      },
      %{
        label: gettext("Admin"),
        icon: "hero-user-solid",
        tab: :clients,
        options: [navigate: ~p"/sign-in"],
        separator: true,
        badge: 1
      }
      # %{
      #   label: gettext("Config"),
      #   icon: "hero-cog-6-tooth-solid",
      #   tab: :settings,
      #   tabs: [
      #     %{
      #       label: gettext("Account"),
      #       tab: :account,
      #       options: [navigate: ~p"/account"]
      #     },
      #     %{
      #       label: gettext("Notifications"),
      #       tab: :notifications,
      #       options: [navigate: ~p"/notifications"]
      #     }
      #   ]
      # }
      # %{
      #   label: gettext("Logout"),
      #   icon: "hero-arrow-left-end-on-rectangle-solid",
      #   options: [
      #     href: ~p"/",
      #     method: "delete",
      #     "data-confirm": gettext("¿Are you sure?")
      #   ]
      # }
    ]
  end
end
