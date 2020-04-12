defmodule ScriptureWeb.Router do
  use ScriptureWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ScriptureWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/admin", ScriptureWeb.Admin, as: :admin do
    pipe_through :browser

    resources "/users", UserController
  end
end
