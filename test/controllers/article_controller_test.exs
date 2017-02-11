defmodule Scripture.ArticleControllerTest do
  use Scripture.ConnCase, async: true

  setup %{conn: conn} do
    user = persist_fixture(:user)
    {:ok, conn: log_in_as(conn, user), user: user}
  end

  test "lists all published entries on index", %{conn: conn} do
    article = persist_fixture(:article)
    unpublished_article = persist_fixture(:article, %{published: false, title: "Draft"})
    conn = get conn, article_path(conn, :index)
    assert html_response(conn, 200) =~ article.title
    refute html_response(conn, 200) =~ unpublished_article.title
  end

  test "shows chosen article with comments", %{conn: conn, user: user} do
    article = persist_fixture(:article)
    comment = persist_fixture(:comment, %{user_id: user.id, article_id: article.id})
    conn = get conn, article_path(conn, :show, article)
    assert html_response(conn, 200) =~ article.content
    assert html_response(conn, 200) =~ comment.message
  end

  test "doesn't show unpublished article", %{conn: conn} do
    article = persist_fixture(:article, %{published: false})

    assert_raise Ecto.NoResultsError, fn ->
      get conn, article_path(conn, :show, article)
    end
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, article_path(conn, :show, -1)
    end
  end
end
