defmodule Scripture.Acceptance.CommentTest do
  use Scripture.AcceptanceCase, async: true

  alias Scripture.{User, Article, Comment}

  setup %{session: session} do
    user = persist_fixture(User)
    article = persist_fixture(Article, %{content: "### Headline\n*emphasis*"})

    article_author = persist_fixture(User, %{email: "other@example.com"})
    persist_fixture(Comment, %{user_id: article_author.id, article_id: article.id})

    {:ok, session: log_in_as(session, user), user: user, article: article}
  end

  test "write comment", %{session: session, article: article} do
    visit(session, "/articles/#{article.id}")

    comment_message = "Super Artikel!"

    fill_in(session, Query.text_field("comment_message"), with: comment_message)
    click(session, Query.button("Kommentar speichern"))

    alert =
      session
      |> all(Query.css(".alert-info"))
      |> List.first

    assert_text(alert, "Kommentar gespeichert.")

    comments_section =
      session
      |> all(Query.css("#comments-section"))
      |> List.first

    assert_text(comments_section, comment_message)
  end

  test "delete links are only rendered for self-created comments", %{session: session, article: article, user: user} do
    comment_message = "Super Artikel!"
    persist_fixture(Comment, %{user_id: user.id, article_id: article.id, message: comment_message})

    visit(session, "/articles/#{article.id}")

    assert_has session, Query.css("#comments-section .comment-header", count: 2)

    # only one delete link means I can't delete other user's comments
    assert_has session, Query.css("#comments-section a.delete", count: 1)
  end

  test "delete comment", %{session: session, article: article, user: user} do
    comment_message = "Super Artikel!"
    persist_fixture(Comment, %{user_id: user.id, article_id: article.id, message: comment_message})

    visit(session, "/articles/#{article.id}")

    comment_count = Scripture.Repo.aggregate(from(c in Comment, where: c.article_id == ^article.id), :count, :id)

    assert 2 == comment_count

    accept_confirm(session, fn(s) ->
      click(s, Query.css("a.delete"))
    end)

    alert_query = Query.css(".alert-info")

    alert =
      session
      |> all(alert_query)
      |> List.first

    assert_has session, alert_query
    assert_text(alert, "Kommentar gelöscht.")

    comment_count = Scripture.Repo.aggregate(from(c in Comment, where: c.article_id == ^article.id), :count, :id)

    assert 1 == comment_count
  end
end
