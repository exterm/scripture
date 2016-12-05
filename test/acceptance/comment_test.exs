defmodule Scripture.Acceptance.CommentTest do
  use Scripture.AcceptanceCase, async: true

  setup %{session: session} do
    user = persist_fixture(:user)
    article = persist_fixture(:article, %{content: "### Headline\n*emphasis*"})
    
    other_user = persist_fixture(:user, %{email: "other@example.com"})
    persist_fixture(:comment, %{user_id: other_user.id, article_id: article.id})

    {:ok, session: log_in_as(session, user), user: user, article: article}
  end

  test "write comment", %{session: session, article: article} do
    visit(session, "/articles/#{article.id}")

    comment_message = "Super Artikel!"
    
    fill_in(session, "comment_message", with: comment_message)
    click_on(session, "Kommentar speichern")

    alert =
      session
      |> all(".alert-info")
      |> List.first
    
    assert_text(alert, "Kommentar gespeichert.")

    comments_section =
      session
      |> all("#comments-section")
      |> List.first

    assert_text(comments_section, comment_message)
  end

  test "delete links are only rendered for self-created comments", %{session: session, article: article, user: user} do
    comment_message = "Super Artikel!"
    persist_fixture(:comment, %{user_id: user.id, article_id: article.id, message: comment_message})

    visit(session, "/articles/#{article.id}")
    
    comment_headers =
      session
      |> find("#comments-section")
      |> all(".comment-header")

    assert 2 == length(comment_headers)

    delete_links =
      session
      |> find("#comments-section")
      |> all("a.delete")

    # only one delete link means I can't delete other user's comments
    assert 1 == length(delete_links)
  end
end
