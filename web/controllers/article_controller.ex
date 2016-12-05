defmodule Scripture.ArticleController do
  use Scripture.Web, :controller

  alias Scripture.Article
  alias Scripture.Comment

  def index(conn, _params) do
    articles = Article
      |> Article.published
      |> Repo.all
    render(conn, "index.html", articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article.with_comments, id)

    comment_changeset = Comment.changeset(%Comment{})

    render(conn, "show.html", article: article, comment_changeset: comment_changeset)
  end
end
