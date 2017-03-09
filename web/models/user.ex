defmodule Scripture.User do
  use Scripture.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :login_token, :string
    field :login_token_created_at, Ecto.DateTime
    field :role, :string
    field :group, :string
    has_many :comments, Scripture.Comment

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
          :first_name,
          :last_name,
          :email,
          :login_token,
          :login_token_created_at])
    |> general_validations
  end

  def admin_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
          :first_name,
          :last_name,
          :email,
          :login_token,
          :login_token_created_at,
          :role,
          :group])
    |> validate_inclusion(:role, roles())
    |> validate_inclusion(:group, groups())
    |> general_validations
  end

  @doc """
  Generates a new login token
  """
  def new_login_token(timestamp \\ DateTime.utc_now()) do
    %{
      login_token: :crypto.hash(:sha512, to_string(timestamp)) |> Base.encode16,
      login_token_created_at: timestamp
    }
  end

  def roles, do: ["reader", "admin"]
  def groups, do: ["close family", "family", "friends", "acquaintances"]

  defp general_validations(changeset) do
    changeset
    |> validate_required([:first_name, :last_name, :email])
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:login_token)
  end
end
