defmodule Scripture.Admin.ArticleControllerTest do
  use Scripture.ConnCase, async: true

  alias Scripture.Article
  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  alias Scripture.{User, Article}

  setup %{conn: conn} do
    user = persist_fixture(User, :admin)
    {:ok, conn: log_in_as(conn, user)}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_article_path(conn, :index)
    assert html_response(conn, 200) =~ "Articles Admin"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_article_path(conn, :new)
    assert html_response(conn, 200) =~ "New article"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_article_path(conn, :create), article: @valid_attrs
    assert redirected_to(conn) == admin_article_path(conn, :index)
    assert Repo.get_by(Article, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_article_path(conn, :create), article: @invalid_attrs
    assert html_response(conn, 200) =~ "New article"
  end

  test "shows chosen resource", %{conn: conn} do
    article = persist_fixture(Article)
    conn = get conn, admin_article_path(conn, :show, article)
    assert html_response(conn, 200) =~ "Article Preview"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_article_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    article = persist_fixture(Article)
    conn = get conn, admin_article_path(conn, :edit, article)
    assert html_response(conn, 200) =~ "Edit article"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    article = persist_fixture(Article)
    conn = put conn, admin_article_path(conn, :update, article), article: @valid_attrs
    assert redirected_to(conn) == admin_article_path(conn, :show, article)
    assert Repo.get_by(Article, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    article = Repo.insert! %Article{}
    conn = put conn, admin_article_path(conn, :update, article), article: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit article"
  end

  test "deletes chosen resource", %{conn: conn} do
    article = persist_fixture(Article)
    conn = delete conn, admin_article_path(conn, :delete, article)
    assert redirected_to(conn) == admin_article_path(conn, :index)
    refute Repo.get(Article, article.id)
  end
end
