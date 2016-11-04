defmodule Scripture.SessionHelper do
  @session Plug.Session.init(
    store: :cookie,
    key: "_app",
    encryption_salt: "yadayada",
    signing_salt: "yadayada"
  )

  defmacro __using__(_) do
    quote do
      import Scripture.SessionHelper
    end
  end

  def with_session(conn) do
    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(@session)
    |> Plug.Conn.fetch_session
    |> Phoenix.Controller.fetch_flash
    |> Plug.Conn.fetch_query_params
  end

  def log_in_as(conn, user) do
    Plug.Conn.assign(conn, :current_user, user)
  end
end
