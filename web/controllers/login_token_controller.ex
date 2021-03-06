defmodule Scripture.LoginTokenController do
  use Scripture.Web, :controller
  import Scripture.LoginTokenService, only: [create_and_send_token: 2]
  alias Scripture.User

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"login_token_create" => form_params}) do
    case Repo.get_by(User, email: String.downcase(form_params["email"])) do
      nil ->
        conn
        |> put_flash(:error, "Ich kenne keinen Nutzer mit dieser E-Mail-Adresse.")
        |> render("new.html")
      user ->
        create_and_send_token(user, form_params["requested_path"])

        conn
        |> put_flash(:success, "Du solltest innerhalb weniger Sekunden eine Email mit einem Login-Link an #{form_params["email"]} bekommen. Um dich einzuloggen, klicke einfach auf den Link in der Email.")
        |> redirect(to: "/login_token_created")
    end
  end

  def success(conn, _params), do: render(conn, "success.html")
end
