defmodule Scripture.Repo.Migrations.AddUserGroups do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :group, :string
    end
  end
end
