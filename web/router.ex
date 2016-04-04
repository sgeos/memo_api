defmodule MemoApi.Router do
  use MemoApi.Web, :router

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

  pipeline :secure_api do
    plug :api
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: MemoApi.Auth
  end

  scope "/", MemoApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", MemoApi do
    pipe_through :api

    get "/", ApiController, :index
    post "/register", UserController, :create
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/api", MemoApi do
    pipe_through :secure_api

    resources "/users", UserController, except: [:create, :new, :edit]
    resources "/memos", MemoController, except: [:new, :edit]
  end
end

