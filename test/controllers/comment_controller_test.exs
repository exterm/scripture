defmodule Scripture.CommentControllerTest do
  use Scripture.ConnCase, async: true

  alias Scripture.Comment

  setup %{conn: conn} do
    article = persist_fixture(:article)
    user = persist_fixture(:user)
    {:ok, conn: log_in_as(conn, user), user: user, article: article}
  end

  test "creates comment", %{conn: conn, user: user, article: article} do
    comment_attrs = %{message: "Hello!", article_id: article.id, user_id: user.id}
    conn = post conn, comment_path(conn, :create), comment: comment_attrs
    assert redirected_to(conn) == article_path(conn, :show, article)
    assert Repo.get_by(Comment, comment_attrs)
  end

  test "deletes comment", %{conn: conn, user: user, article: article} do
    comment = persist_fixture(:comment, %{article_id: article.id, user_id: user.id})
    conn = delete conn, comment_path(conn, :delete, comment)
    assert redirected_to(conn) == article_path(conn, :show, article)
    refute Repo.get(Comment, comment.id)
    assert get_flash(conn) == %{"info" => "Kommentar gelöscht."}
  end

  test "can't delete other user's comment", %{conn: conn, article: article} do
    other_user = persist_fixture(:user, %{email: "other@example.com"})
    comment = persist_fixture(:comment, %{article_id: article.id, user_id: other_user.id})

    conn = delete conn, comment_path(conn, :delete, comment)

    assert redirected_to(conn) == article_path(conn, :show, article)
    assert Repo.get(Comment, comment.id)
    assert get_flash(conn) == %{}
  end

  test "renders article with error message when submitting comment form without content",
    %{conn: conn, user: user, article: article} do

    comment_attrs = %{message: "", article_id: article.id, user_id: user.id}
    conn = post conn, comment_path(conn, :create), comment: comment_attrs
    assert redirected_to(conn) == article_path(conn, :show, article)
    refute Repo.get_by(Comment, comment_attrs)
    assert get_flash(conn) == %{"error" => "Kommentar konnte nicht gespeichert werden."}
  end
end
