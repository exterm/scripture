defmodule Scripture.LoginPlugTest do
  use Scripture.ConnCase, async: true

  @opts Scripture.LoginPlug.init([])

  setup do
    {:ok, user: persist_fixture(:user)}
  end

  test "current_user is nil if no logged in user and login impossible" do
    conn = build_conn(:get, "/dummy")
      |> with_session
      |> Scripture.LoginPlug.call(@opts)

    assert conn.assigns[:current_user] == nil
  end

  test "user is logged in when using correct token", %{user: user} do
    conn = build_conn(:get, "/dummy?login_token=#{user.login_token}")
      |> with_session
      |> Scripture.LoginPlug.call(@opts)

    assert conn.assigns[:current_user] == user
    assert get_session(conn, :current_user) == user.id
  end

  test "logged in user is correctly recognized", %{user: user} do
    conn = build_conn(:get, "/dummy")
      |> with_session
      |> put_session(:current_user, user.id)
      |> Scripture.LoginPlug.call(@opts)

    assert conn.assigns[:current_user] == user
  end
end
