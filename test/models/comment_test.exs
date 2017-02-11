defmodule Scripture.CommentTest do
  use Scripture.ModelCase

  alias Scripture.Comment

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
end
