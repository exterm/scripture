defmodule Scripture.SessionHelper do
  import Phoenix.ConnTest, only: [build_conn: 0, bypass_through: 3]

  defmacro __using__(_) do
    quote do
      import Scripture.SessionHelper
    end
  end

  def browser_conn() do
    bypass_through(build_conn(), Scripture.Router, [:browser])
  end

  def log_in_as(conn, user) do
    Plug.Conn.assign(conn, :current_user, user)
  end
end
