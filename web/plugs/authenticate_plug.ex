defmodule Scripture.AuthenticatePlug do
  use Scripture.Web, :plug

  @roles [:reader, :admin]
  
  def init(role) when role in @roles, do: role

  def call(conn, _role) do
    user = conn.assigns[:current_user]

    # TODO if user && user.role == role
    if user do
      conn
    else
      conn
      |> Phoenix.Controller.put_flash(:error, "Bitte logge dich ein, um auf diese Seite zuzugreifen.")
      |> Phoenix.Controller.redirect(to: "/send_login_token")
      |> halt
    end
  end
end
