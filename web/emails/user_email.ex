defmodule Scripture.UserEmail do
  use Phoenix.Swoosh, view: Scripture.EmailView, layout: {Scripture.LayoutView, :email}

  import Scripture.UserView, only: [full_name: 1]

  def login_token(user) do
    new()
    |> to({full_name(user), user.email})
    |> from({"Anna und Philip", "blog@annaundphilip.info"})
    |> subject("Login bei Anna und Philips Blog")
    |> render_body("login_token.html", %{token: user.login_token})
  end
end
