defmodule Scripture.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :content, :string

      timestamps
    end

  end
end
