defmodule Scripture.HelloController do
  use Scripture.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end
end
