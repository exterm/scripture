defmodule Scripture.Router do
  use Scripture.Web, :router
  use Plug.ErrorHandler

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Scripture.LoginPlug
  end

  pipeline :reader_authentication do
    plug Scripture.AuthenticatePlug, :reader
  end

  pipeline :admin_authentication do
    plug Scripture.AuthenticatePlug, :admin
  end

  # public routes
  scope "/", Scripture do
    pipe_through :browser # Use the default browser stack

    get "/send_login_token", LoginTokenController, :new
    post "/send_login_token", LoginTokenController, :create
    get "/login_token_created", LoginTokenController, :success
  end

  # reader routes
  # TODO namespacing for reader area
  scope "/", Scripture do
    pipe_through [:browser, :reader_authentication]

    get "/", HomepageController, :index
  end

  # admin routes
  scope "/admin", Scripture.Admin, as: :admin do
    pipe_through [:browser, :admin_authentication]

    resources "/articles", ArticleController
  end

  if Mix.env == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview, [base_path: "/dev/mailbox"]
    end
  end

  # don't report routing errors
  defp handle_errors(_conn, %{reason: %Phoenix.Router.NoRouteError{}}), do: nil
  # report all other errors
  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    rollbar_standard_metadata = Scripture.ExceptionReporter.rollbar_standard_metadata(conn)
    custom_data = %{}
    Rollbax.report(kind, reason, stacktrace, custom_data, rollbar_standard_metadata)
  end
end
