defmodule Scripture.UserEmail do
  use Phoenix.Swoosh, view: Scripture.EmailView, layout: {Scripture.LayoutView, :email}

  def login_token(user) do
    new
    |> to({user.first_name <> " " <> user.last_name, user.email})
    |> from({"Anna und Philip", "blog@annaundphilip.info"})
    |> reply_to("annaundphilip-blog@philip.in-aachen.net")
    |> subject("Login bei Anna und Philips Blog")
    |> render_body("login_token.html", %{token: user.login_token})
  end
end
