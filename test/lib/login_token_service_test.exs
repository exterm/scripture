defmodule Scripture.LoginTokenServiceTest do
  use Scripture.LibCase, async: true

  import Swoosh.TestAssertions

  alias Scripture.LoginTokenService

  test "create_and_send_token" do
    user = persist_fixture(:user, %{login_token: nil})

    assert nil == user.login_token

    LoginTokenService.create_and_send_token(user)

    assert_email_sent subject: "Login bei Anna und Philips Blog"
    assert nil != Repo.get(Scripture.User, user.id).login_token
  end

  test "login_and_get_user success" do
    user = persist_fixture(:user)

    assert nil != LoginTokenService.login_and_get_user(user.login_token)
  end

  test "login_and_get_user outdated token" do
    {:ok, really_old_timestamp} = DateTime.from_unix(0)
    user = persist_fixture(:user, %{login_token_created_at: really_old_timestamp})

    assert nil == LoginTokenService.login_and_get_user(user.login_token)
  end

  test "login_and_get_user wrong token" do
    persist_fixture(:user)

    assert nil == LoginTokenService.login_and_get_user("THIS IS NOT A TOKEN")
  end
end
