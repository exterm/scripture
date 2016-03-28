defmodule Scripture.Router do
  use Scripture.Web, :router
  use Plug.ErrorHandler

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

  scope "/", Scripture do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/articles", ArticleController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Scripture do
  #   pipe_through :api
  # end


  # don't report routing errors
  defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{}}), do: nil
  defp handle_errors(_conn, %{kind: _kind, reason: exception, stack: stacktrace}) do
    Rollbax.report(exception, stacktrace)
  end
end
