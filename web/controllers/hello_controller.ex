defmodule Scripture.HelloController do
  use Scripture.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end

  def show(conn, params = %{"messenger" => messenger}) do
    conn
    |> put_flash(:info, params["info"])
    |> put_flash(:error, "fake error!")
    |> put_flash(:success, "fake success!")
    |> render(:show, messenger: messenger)
  end
end
