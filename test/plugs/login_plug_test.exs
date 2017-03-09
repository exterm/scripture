defmodule Scripture.LoginPlugTest do
  use Scripture.ConnCase, async: true

  @opts Scripture.LoginPlug.init([])

  alias Scripture.User

  setup do
    {:ok, user: persist_fixture(User)}
  end

  test "current_user is nil if no logged in user and login impossible" do
    conn = browser_conn()
      |> get("/dummy")
      |> Scripture.LoginPlug.call(@opts)

    assert conn.assigns[:current_user] == nil
  end

  test "user is logged in when using correct token", %{user: user} do
    conn = browser_conn()
      |> get("/dummy?login_token=#{user.login_token}")
      |> Scripture.LoginPlug.call(@opts)

    assert conn.assigns[:current_user] == user
    assert get_session(conn, :current_user) == user.id
  end

  test "logged in user is correctly recognized", %{user: user} do
    conn = browser_conn()
      |> get("/dummy")
      |> put_session(:current_user, user.id)
      |> Scripture.LoginPlug.call(@opts)

    assert conn.assigns[:current_user] == user
  end
end
