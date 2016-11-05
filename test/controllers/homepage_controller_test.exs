defmodule Scripture.HomepageControllerTest do
  use Scripture.ConnCase, async: true

  setup %{conn: conn} do
    user = persist_fixture(:user)
    {:ok, conn: log_in_as(conn, user)}
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"

    html_response(conn, 200)

    # TODO articles index
    # assert html_response(conn, 200) =~ "Hier sind die neusten Artikel gelistet"
  end
 end
