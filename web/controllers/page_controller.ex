defmodule Scripture.PageController do
  use Scripture.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end
end
