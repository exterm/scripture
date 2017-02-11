defmodule Scripture.Article do
  use Scripture.Web, :model

  schema "articles" do
    field :title, :string
    field :content, :string
    field :published, :boolean
    has_many :comments, Scripture.Comment, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :published])
    |> validate_required([:title, :content])
  end

  # https://blog.drewolson.org/composable-queries-ecto/
  def published(query \\ Scripture.Article) do
    from a in query,
    where: a.published
  end

  def with_comments(query \\ Scripture.Article) do
    from q in query, preload: [comments: :user]
  end
end
