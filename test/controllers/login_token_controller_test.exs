defmodule Scripture.LoginTokenControllerTest do
  use Scripture.ConnCase, async: true

  import Swoosh.TestAssertions

  alias Scripture.User

  test "renders login form", %{conn: conn} do
    conn = get conn, login_token_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "creates login token, sends email and redirects when user exists", %{conn: conn} do
    user = persist_fixture(User)

    conn = post conn, login_token_path(conn, :create), login_token_create: %{email: user.email, requested_path: "/some/path"}
    assert redirected_to(conn) == login_token_path(conn, :success)

    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ "Login-Link an #{user.email}"

    changed_user = Repo.get!(User, user.id)
    assert changed_user.login_token != user.login_token
    assert_email_sent Scripture.UserEmail.login_token(changed_user, "/some/path")
  end

  test "does not create login token and renders error when user not found", %{conn: conn} do
    email = "not-existing@example.com"

    conn = post conn, login_token_path(conn, :create), login_token_create: %{email: email}
    assert html_response(conn, 200) =~ "Ich kenne keinen Nutzer mit dieser E-Mail-Adresse."
  end
end
