defmodule Scripture.SessionController do
  use Scripture.Web, :controller

  alias Scripture.User

  def new(conn, _params) do
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"email" => email, "password" => password}) do

    user = Repo.get_by!(User, email: email)

    if Comeonin.Ecto.Password.valid?(password, user.hashed_password) do
      conn
      |> create_session(user)
      |> redirect(to: page_path(conn, :index)
    else
      conn
      |> put_flash(:error, "login data wrong")
      |> redirect(to: session_path(conn, :new))
    end
  end
end
