defmodule CaissaWeb.Router do
  use CaissaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CaissaWeb do
    pipe_through :browser

    resources("/categories", CategoryController, only: [:index, :show])
    resources("/games", GameController, only: [:index, :show])
    resources("/players", PlayerController, only: [:index, :show])
    resources("/files", FileController, only: [:new, :create])

    get "/", PageController, :index
  end

  forward "/api",
    Absinthe.Plug,
    schema: CaissaWeb.Schema,
    json_codec: Jason,
    socket: CaissaWeb.UserSocket

  # Note: downloaded from CDN!
  forward "/graphiql",
    Absinthe.Plug.GraphiQL,
    schema: CaissaWeb.Schema,
    json_codec: Jason,
    socket: CaissaWeb.UserSocket

  # Other scopes may use custom stacks.
  # scope "/api", CaissaWeb do
  #   pipe_through :api
  # end
end
