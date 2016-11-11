defmodule Scripture.AuthenticatePlug do
  use Scripture.Web, :plug

  alias Scripture.User

  @roles ["reader", "admin"]

  def init(role) when role in @roles, do: role

  def call(conn, role) do
    user = conn.assigns[:current_user]

    case user do
      %User{role: ^role} -> conn
      %User{role: "admin"} -> conn # admin is allowed everywhere
      nil -> # not logged in
        conn
        |> put_status(403)
        |> Phoenix.Controller.put_flash(:info, "Bitte logge dich ein, um auf diese Seite zuzugreifen.")
        |> Phoenix.Controller.put_layout({Scripture.LayoutView, "app.html"})
        |> Phoenix.Controller.render(Scripture.LoginTokenView, :new)
        |> halt
      _other -> # user doesn't have an allowed role
        conn
        |> put_status(403)
        |> Phoenix.Controller.put_flash(:error, "Du bist nicht berechtigt, auf diese Seite zuzugreifen.")
        |> Phoenix.Controller.put_layout({Scripture.LayoutView, "app.html"})
        |> Phoenix.Controller.render(Scripture.ErrorView, "403.html")
        |> halt
    end
  end
end
