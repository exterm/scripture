defmodule Scripture.Repo.Migrations.AddPublishedToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :published, :bool, default: false
    end
  end
end
