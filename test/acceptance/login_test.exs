defmodule Scripture.Acceptance.LoginTest do
  use Scripture.AcceptanceCase, async: true

  alias Scripture.User

  test "login flow part 1: prompt", %{session: session} do
    body =
      session
      |> visit("/")
      |> find(Query.css("body"))

    # no redirect
    assert current_path(session) == "/"

    flash_content =
      session
      |> all(Query.css("p.alert.alert-info"))
      |> List.first

    assert_text(flash_content, "logge dich ein")
    assert_text(body, "Sende mir einen Login-Link")
  end

  test "login flow part 2: logging in", %{session: session} do
    user = persist_fixture(User)

    body =
      session
      |> visit(Scripture.EmailView.login_link(user.login_token, "/"))
      |> find(Query.css("body"))

    # no redirect
    assert current_path(session) == "/"

    assert_text(body, "Oh, wie schön ist")
  end

end
