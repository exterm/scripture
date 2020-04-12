defmodule Scripture.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string

      add :login_token, :string
      add :login_token_created_at, :utc_datetime

      add :role, :string
      add :group, :string

      timestamps()
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:login_token])

  end
end
