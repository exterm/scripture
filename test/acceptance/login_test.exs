defmodule Scripture.Acceptance.LoginTest do
  use Scripture.AcceptanceCase, async: true

  test "login flow part 1: redirect", %{session: session} do
    body = session
      |> visit("/")
      |> find("body")

    # no redirect
    assert get_current_path(body) == "/"

    flash_content =
      session
      |> all("p.alert.alert-info")
      |> List.first

    assert_text(flash_content, "logge dich ein")
    assert_text(body, "Sende mir einen Login-Link")
  end

  test "login flow part 2: logging in", %{session: session} do
    user = persist_fixture(:user)
    log_in_as(session, user)
  end

end
