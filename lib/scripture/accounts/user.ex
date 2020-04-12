defmodule Scripture.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :login_token, :string
    field :login_token_created_at, :utc_datetime
    field :role, :string
    field :group, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
          :first_name,
          :last_name,
          :email,
          :login_token,
          :login_token_created_at])
    |> general_validations
  end

  def admin_changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [
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
