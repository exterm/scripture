defmodule Scripture.Repo.Migrations.AddLoginTokenToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :login_token, :string
      add :login_token_created_at, :datetime
    end

    create unique_index(:users, [:login_token])
  end
end
