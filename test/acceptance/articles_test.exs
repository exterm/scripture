defmodule Scripture.Acceptance.ArticlesTest do
  use Scripture.AcceptanceCase, async: true

  setup %{session: session} do
    user = persist_fixture(:user)
    {:ok, session: log_in_as(session, user)}
  end

  test "create article", %{session: session} do
    article_title = "Batman"

    session
    |> visit("/admin/articles")
    |> click_link("New article")

    session
    |> fill_in("Title", with: article_title)
    |> fill_in("Content", with: "The Dark Knight Returns")
    |> click_on("Submit")

    first_title =
      session
      |> all("td.article-title")
      |> List.first

    assert_text(first_title, article_title)
  end
end
