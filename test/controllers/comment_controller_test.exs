defmodule Scripture.CommentControllerTest do
  use Scripture.ConnCase, async: true

  alias Scripture.{User, Article, Comment}

  import Swoosh.TestAssertions

  setup %{conn: conn} do
    article = persist_fixture(Article)
    user = persist_fixture(User)
    {:ok, conn: log_in_as(conn, user), user: user, article: article}
  end

  test "creates comment", %{conn: conn, user: user, article: article} do
    admin = persist_fixture(User, :admin)
    admin2 = persist_fixture(User, :admin, %{email: "bernd@berndes.com"})
    comment_attrs = %{message: "Hello!", article_id: article.id, user_id: user.id}

    conn = post conn, comment_path(conn, :create), comment: comment_attrs

    assert redirected_to(conn) == article_path(conn, :show, article)
    assert Repo.get_by(Comment, comment_attrs)
    assert_email_sent to: {Scripture.UserView.full_name(admin), admin.email}
    assert_email_sent to: {Scripture.UserView.full_name(admin2), admin2.email}
  end

  test "creating comment does not send notification to the author", %{conn: conn, article: article} do
    admin_author = persist_fixture(User, :admin)
    comment_attrs = %{message: "Hello!", article_id: article.id, user_id: admin_author.id}

    post conn, comment_path(conn, :create), comment: comment_attrs

    assert_email_not_sent to: {Scripture.UserView.full_name(admin_author), admin_author.email}
  end

  test "deletes comment", %{conn: conn, user: user, article: article} do
    comment = persist_fixture(Comment, %{article_id: article.id, user_id: user.id})

    conn = delete conn, comment_path(conn, :delete, comment)

    assert redirected_to(conn) == article_path(conn, :show, article)
    refute Repo.get(Comment, comment.id)
    assert get_flash(conn) == %{"info" => "Kommentar gelöscht."}
  end

  test "can't delete other user's comment", %{conn: conn, article: article} do
    other_user = persist_fixture(User, %{email: "other@example.com"})
    comment = persist_fixture(Comment, %{article_id: article.id, user_id: other_user.id})

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
