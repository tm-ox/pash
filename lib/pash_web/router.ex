defmodule PashWeb.Router do
  # use Phoenix.Router
  use PashWeb, :router

  # import AshAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PashWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PashWeb do
    pipe_through :browser

    live_session :default, on_mount: [PashWeb.TabManager] do
      live "/", HomeLive, :index

      # get "/", PageController, :home
      # Blog
      live "/blog", PostLive.Index, :index
      live "/blog/new", PostLive.Index, :new
      live "/blog/:id/edit", PostLive.Index, :edit
      live "/blog/:id", PostLive.Show, :show
      live "/blog/:id/show/edit", PostLive.Show, :edit
    end
  end

  import AshAdmin.Router

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
