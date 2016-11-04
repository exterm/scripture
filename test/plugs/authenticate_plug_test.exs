defmodule Scripture.AuthenticatePlugTest do
  use Scripture.ConnCase

  @opts Scripture.AuthenticatePlug.init(:reader)

  test "triggers redirect if no logged in user" do
    conn = build_conn(:get, "/admin/articles")
    |> with_session
    |> Scripture.AuthenticatePlug.call(@opts)

    assert conn.status == 302
    assert redirected_to(conn) == "/send_login_token"
    assert String.contains?(get_flash(conn, :error), "Bitte logge dich ein")
  end

  test "does not trigger redirect if logged in user" do
    conn = build_conn(:get, "/admin/articles")
      |> assign(:current_user, persist_fixture(:user))
      |> Scripture.AuthenticatePlug.call(@opts)

    assert conn.status == nil # no answer yet
  end
end
