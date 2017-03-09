defmodule Scripture.Article do
  use Scripture.Web, :model

  schema "articles" do
    field :title, :string
    field :content, :string
    field :published, :boolean, virtual: true
    field :published_at, :utc_datetime
    has_many :comments, Scripture.Comment, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :published])
    |> published_to_published_at()
    |> validate_required([:title, :content])
  end

  # https://blog.drewolson.org/composable-queries-ecto/
  def published(query \\ Scripture.Article) do
    from a in query,
      where: not(is_nil(a.published_at)),
      order_by: [desc: :published_at]
  end

  def with_comments(query \\ Scripture.Article) do
    from q in query, preload: [comments: :user]
  end

  def published?(article) do
    article.published_at != nil
  end

  def published_to_published_at(changeset, timestamp \\ DateTime.utc_now()) do
    with_published_at =
      case {changeset.changes[:published], changeset.data.published_at} do
        {true,  nil} -> put_change(changeset, :published_at, timestamp)
        {false, _  } -> put_change(changeset, :published_at, nil)
        _            -> changeset
      end

    delete_change(with_published_at, :published)
  end
end
