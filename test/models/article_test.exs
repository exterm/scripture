defmodule Scripture.ArticleTest do
  use Scripture.ModelCase, async: true

  alias Scripture.Article

  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Article.changeset(%Article{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "published query" do
    _unpublished_article = persist_fixture(:article, %{published: false, title: "Draft"})
    published_article = persist_fixture(:article)

    articles = Repo.all(Article.published)

    assert [published_article] == articles
  end

  test "with_comments method" do
    user = persist_fixture(:user)
    article = persist_fixture(:article)
    persist_fixture(:comment, %{user_id: user.id, article_id: article.id})

    resulting_article = Repo.get!(Article.with_comments, article.id)
    assert nil != List.first(resulting_article.comments).user
  end

  test "deleting an article also deletes its comments" do
    user = persist_fixture(:user)
    article = persist_fixture(:article)
    comment = persist_fixture(:comment, %{user_id: user.id, article_id: article.id})

    assert comment == Repo.get(Scripture.Comment, comment.id)

    Repo.delete!(article)

    assert nil == Repo.get(Scripture.Comment, comment.id)
  end
end
