defmodule Scripture.AuthenticatePlugTest do
  use Scripture.ConnCase, async: true

  @opts Scripture.AuthenticatePlug.init("reader")

  test "denies access if no logged in user" do
    conn = browser_conn()
    |> get("/admin/articles")
    |> Phoenix.Controller.accepts(["html"])
    |> Scripture.AuthenticatePlug.call(@opts)

    assert conn.status == 403
    assert String.contains?(get_flash(conn, :info), "Bitte logge dich ein")
  end

  test "does not trigger redirect if logged in user" do
    conn = browser_conn()
      |> get("/")
      |> log_in_as(persist_fixture(:user))
      |> Scripture.AuthenticatePlug.call(@opts)

    assert conn.status == nil # no answer yet
  end
end
