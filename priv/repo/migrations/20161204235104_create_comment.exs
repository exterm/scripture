defmodule Scripture.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :message, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :article_id, references(:articles, on_delete: :nothing)

      timestamps()
    end
    create index(:comments, [:user_id])
    create index(:comments, [:article_id])
  end
end
