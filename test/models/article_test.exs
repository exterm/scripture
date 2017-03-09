defmodule Scripture.ArticleTest do
  use Scripture.ModelCase, async: true

  alias Scripture.{Article, Comment, User}

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, fixture_defaults(Article))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Article.changeset(%Article{}, %{})
    refute changeset.valid?
  end

  test "published query" do
    _unpublished_article = persist_fixture(Article, %{published: false, title: "Draft"})
    first_published_article = persist_fixture(Article)
    second_published_article = persist_fixture(Article)

    articles = Repo.all(Article.published)

    assert [second_published_article, first_published_article] == articles
  end

  test "with_comments method" do
    user = persist_fixture(User)
    article = persist_fixture(Article)
    persist_fixture(Comment, %{user_id: user.id, article_id: article.id})

    resulting_article = Repo.get!(Article.with_comments, article.id)
    assert nil != List.first(resulting_article.comments).user
  end

  test "deleting an article also deletes its comments" do
    user = persist_fixture(User)
    article = persist_fixture(Article)
    comment = persist_fixture(Comment, %{user_id: user.id, article_id: article.id})

    assert comment == Repo.get(Comment, comment.id)

    Repo.delete!(article)

    assert nil == Repo.get(Comment, comment.id)
  end

  test "published? function" do
    published_article = persist_fixture(Article)
    unpublished_article = persist_fixture(Article, %{published: false})

    assert Article.published?(published_article)
    refute Article.published?(unpublished_article)
  end

  test "set_published_at should set published_at for new published article" do
    changeset = Ecto.Changeset.change(%Article{}, %{published: true})
    new_changeset = Article.published_to_published_at(changeset, timestamp())
    assert timestamp() == new_changeset.changes.published_at
  end

  test "set_published_at should set published_at when publishing existing article" do
    changeset = Ecto.Changeset.change(build_fixture(Article, %{published: false}), %{published: true})
    new_changeset = Article.published_to_published_at(changeset, timestamp())
    assert timestamp() == new_changeset.changes.published_at
  end

  test "set_published_at should not change published_at when editing published article" do
    changeset = Ecto.Changeset.change(build_fixture(Article), %{published: true})
    new_changeset = Article.published_to_published_at(changeset, timestamp())
    assert :no_key == Map.get(new_changeset.changes, :published_at, :no_key)
  end

  test "set_published_at should reset published_at when unpublishing existing article" do
    changeset = Ecto.Changeset.change(build_fixture(Article), %{published: false})
    new_changeset = Article.published_to_published_at(changeset, timestamp())
    assert nil == Map.get(new_changeset.changes, :published_at, :no_key)
  end

  defp timestamp do
    %DateTime{calendar: Calendar.ISO, day: 17, hour: 0, microsecond: {178597, 6},
              minute: 29, month: 10, second: 58, std_offset: 0, time_zone: "Etc/UTC",
              utc_offset: 0, year: 2016, zone_abbr: "UTC"}
  end
end
