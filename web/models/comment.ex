defmodule Scripture.Comment do
  use Scripture.Web, :model

  schema "comments" do
    field :message, :string
    belongs_to :user, Scripture.User
    belongs_to :article, Scripture.Article

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message, :article_id, :user_id])
    |> validate_required([:message, :article_id, :user_id])
    |> update_change(:message, &compact_whitespace/1)
  end

  defp compact_whitespace(string) do
    Regex.replace(~r/(\s)+/, string, "\\1")
  end
end
