defmodule Scripture.Repo.Migrations.RemovePublishedFromArticles do
  use Ecto.Migration

  def up do
    alter table(:articles) do
      remove :published
    end
  end

  def down do
    alter table(:articles) do
      add :published, :bool, default: false
    end
  end
end
