defmodule Scripture.LoginTokenControllerTest do
  use Scripture.ConnCase

  alias Scripture.User
  
  test "renders login form", %{conn: conn} do
    conn = get conn, login_token_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "creates login token and redirects when user exists", %{conn: conn} do
    user = persist_fixture(:user)

    conn = post conn, login_token_path(conn, :create), login_token_create: %{email: user.email}
    assert redirected_to(conn) == login_token_path(conn, :success)

    conn = get conn, redirected_to(conn)
    assert html_response(conn, 200) =~ "Login link sent to #{user.email}"

    assert Repo.get!(User, user.id).login_token
  end

  test "does not create login token and renders error when user not found", %{conn: conn} do
    email = "not-existing@example.com"

    conn = post conn, login_token_path(conn, :create), login_token_create: %{email: email}
    assert html_response(conn, 200) =~ "No user found with that email"
  end
end