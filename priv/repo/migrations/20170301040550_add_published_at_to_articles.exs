defmodule Scripture.Repo.Migrations.AddPublishedAtToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :published_at, :utc_datetime
    end
  end
end
