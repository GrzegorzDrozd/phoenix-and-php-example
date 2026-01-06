defmodule PhoenixAppWeb.Router do
  use PhoenixAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PhoenixAppWeb.Plugs.ApiTokenAuth
  end

  scope "/api", PhoenixAppWeb do
    pipe_through :api
    post "/import", ImportController, :create
    get "/import", ImportController, :show
    resources "/users", UserController, except: [:new, :edit]
  end
end
