defmodule Scripture.CommentTest do
  use Scripture.ModelCase

  alias Scripture.{Comment, Article, User}

  @valid_attrs %{message: "some content", article_id: 42, user_id: 1337}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset removes all consecutive whitespace" do
    message = "This has   consecutive\n\nwhitespace"
    changeset = Comment.changeset(%Comment{}, %{message: message, article_id: 42, user_id: 1337})
    assert "This has consecutive\nwhitespace" == changeset.changes.message
  end

  test "comments with long messages can be saved" do
    message = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" <>
      "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" <>
      "123456789012345678901234567890123456789012345678901234567890"

    assert String.length(message) > 255

    user = persist_fixture(User)
    article = persist_fixture(Article)
    persist_fixture(Comment, %{message: message, user_id: user.id, article_id: article.id})
  end
end
