defmodule ScriptureWeb.PageController do
  use ScriptureWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
