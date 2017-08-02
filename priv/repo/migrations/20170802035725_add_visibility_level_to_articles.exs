defmodule Scripture.Repo.Migrations.AddVisibilityLevelToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :visibility_level, :string
    end
  end
end
