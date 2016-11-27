defmodule Scripture.ArticleController do
  use Scripture.Web, :controller

  alias Scripture.Article

  def index(conn, _params) do
    articles = Article
      |> Article.published
      |> Repo.all
    render(conn, "index.html", articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    render(conn, "show.html", article: article)
  end
end
