defmodule PashWeb.Router do
  # use Phoenix.Router
  use PashWeb, :router

  use AshAuthentication.Phoenix.Router

  import AshAuthentication.Plug.Helpers

  import AshAdmin.Router

  # import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PashWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
    plug :set_actor, :user
  end

  scope "/", PashWeb do
    pipe_through :browser

    ash_authentication_live_session :authentication_required,
      on_mount: [{PashWeb.LiveUserAuth, :live_user_required}, PashWeb.TabManager] do
      live "/dash", AdminLive, :index
    end

    live_session :default, on_mount: [PashWeb.TabManager] do
      live "/", HomeLive, :index

      # get "/", PageController, :home
      # Blog
      live "/blog", PostLive.Index, :index
      live "/blog/edit", PostLive.Edit, :index
      live "/blog/new", PostLive.Index, :new
      live "/blog/:id/edit", PostLive.Index, :edit
      live "/blog/:id", PostLive.Show, :show
      live "/blog/:id/show/edit", PostLive.Show, :edit
      # live "/dash", AdminLive, :index
    end

    auth_routes AuthController, Pash.Accounts.User, path: "/auth"
    sign_out_route AuthController

    # Remove these if you'd like to use your own authentication views
    sign_in_route register_path: "/register",
                  reset_path: "/reset",
                  auth_routes_prefix: "/auth",
                  on_mount: [{PashWeb.LiveUserAuth, :live_no_user}],
                  overrides: [PashWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]

    # Remove this if you do not want to use the reset password feature
    reset_route auth_routes_prefix: "/auth",
                overrides: [PashWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default]
  end

  # scope "/", PashWeb do
  #   pipe_through :browser

  #   ash_authentication_live_session :authenticated_routes, on_mount: [PashWeb.TabManager] do
  #     # in each liveview, add one of the following at the top of the module:
  #     #
  #     # If an authenticated user must be present:
  #     # on_mount {PashWeb.LiveUserAuth, :live_user_required}
  #     #
  #     # If an authenticated user *may* be present:
  #     # on_mount {PashWeb.LiveUserAuth, :live_user_optional}
  #     #
  #     # If an authenticated user must *not* be present:
  #     # on_mount {PashWeb.LiveUserAuth, :live_no_user}
  #   end
  # end

  # AshAdmin requires a Phoenix LiveView `:browser` pipeline
  # If you DO NOT have a `:browser` pipeline already, then AshAdmin has a `:browser` pipeline
  # Most applications will not need this:
  # admin_browser_pipeline(:browser)

  # NOTE: `scope/2` here does not have a second argument.
  # If it looks like `scope "/", MyAppWeb`, create a *new* scope, don't copy the contents into your scope
  scope "/" do
    # Pipe it through your browser pipeline
    pipe_through [:browser]

    ash_admin("/admin")
  end

  # Other scopes may use custom stacks.
  # scope "/api", PashWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pash, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PashWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
