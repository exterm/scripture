defmodule Scripture.Acceptance.Admin.ArticlesTest do
  use Scripture.AcceptanceCase, async: true

  alias Scripture.{User, Article}

  setup %{session: session} do
    user = persist_fixture(User, :admin)
    {:ok, session: log_in_as(session, user)}
  end

  test "create article", %{session: session} do
    article_title = "Batman"

    session
    |> visit("/admin/articles")
    |> click(Query.link("New article"))

    session
    |> fill_in(Query.text_field("Title"), with: article_title)
    |> fill_in(Query.text_field("Content"), with: "The Dark Knight Returns")
    |> click(Query.button("Submit"))

    first_title =
      session
      |> all(Query.css("td.article-title"))
      |> List.first

    assert_text(first_title, article_title)
  end

  test "list articles in correct order", %{session: session} do
    persist_fixture(Article, %{title: "First article"})
    persist_fixture(Article, %{title: "Unfinished article", published: false})
    persist_fixture(Article, %{title: "Another unfinished article", published: false})
    persist_fixture(Article, %{title: "Third article"})

    titles =
      session
      |> visit("/admin/articles")
      |> all(Query.css("td.article-title"))
      |> Enum.map(&Element.text/1)

    expected = ["Another unfinished article", "Unfinished article", "Third article", "First article"]

    assert expected == titles
  end
end
