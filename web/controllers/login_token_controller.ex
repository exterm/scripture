defmodule Scripture.LoginTokenController do
  use Scripture.Web, :controller

  alias Scripture.User

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"login_token_create" => form_params}) do
    case Repo.get_by(User, email: String.downcase(form_params["email"])) do
      nil ->
        conn
        |> put_flash(:error, "No user found with that email")
        |> render("new.html")
      user ->
        new_token_params = User.new_login_token
        changeset = User.changeset(user, new_token_params)
        Repo.update!(changeset)

        # TODO remove token logging
        IO.write("-- new login token: #{new_token_params[:login_token]}\n")

        conn
        |> put_flash(:info, "Login link sent to #{form_params["email"]}")
        |> redirect(to: "/login_token_created")
    end
  end

  def success(conn, _params), do: render(conn, "success.html")
end
