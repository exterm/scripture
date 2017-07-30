defmodule Scripture.Acceptance.ArticleTest do
  use Scripture.AcceptanceCase, async: true

  alias Scripture.{User, Article}

  setup %{session: session} do
    user = persist_fixture(User)
    {:ok, session: log_in_as(session, user)}
  end

  test "read article", %{session: session} do
    article = persist_fixture(Article, %{content: "### Headline\n*emphasis*"})

    session
    |> visit("/articles/#{article.id}")

    h3 =
      session
      |> all(Query.css("article h3"))
      |> List.first

    assert_text(h3, "Headline")

    emphasis =
      session
      |> all(Query.css("article em"))
      |> List.first

    assert_text(emphasis, "emphasis")
  end
end
