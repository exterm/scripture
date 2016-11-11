defmodule Scripture.AuthenticatePlugTest do
  use Scripture.ConnCase, async: true

  @opts Scripture.AuthenticatePlug.init("admin")

  test "denies access if no logged in user" do
    conn = browser_conn()
    |> get("/admin/articles")
    |> Scripture.AuthenticatePlug.call(@opts)

    assert conn.status == 403
    assert String.contains?(get_flash(conn, :info), "Bitte logge dich ein")
  end

  test "denies access if unauthorized user" do
    conn = browser_conn()
    |> get("/admin/articles")
    |> log_in_as(persist_fixture(:user))
    |> Scripture.AuthenticatePlug.call(@opts)

    assert conn.status == 403
    assert String.contains?(get_flash(conn, :error), "Du bist nicht berechtigt, auf diese Seite zuzugreifen.")
  end

  test "does not halt connection if logged in authorized user" do
    conn = browser_conn()
      |> get("/")
      |> log_in_as(persist_fixture(:admin))
      |> Scripture.AuthenticatePlug.call(@opts)

    assert conn.status == nil # no answer yet
  end
end
