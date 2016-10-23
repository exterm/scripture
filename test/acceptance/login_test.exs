defmodule Scripture.Acceptance.LoginTest do
  use Scripture.AcceptanceCase, async: true

  test "login flow part 1: redirect", %{session: session} do
    body = session
      |> visit("/")
      |> find("body")

    assert get_current_path(body) == "/send_login_token"

    # TODO assert flash: Du musst dich einloggen
    assert_text(body, "Send login link")
  end

  test "login flow part 2: logging in", %{session: session} do
    user = persist_fixture(:user)
    log_in_as(session, user)
  end

end
