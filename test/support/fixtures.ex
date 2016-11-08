# for more functionality, read http://blog.danielberkompas.com/elixir/2015/07/16/fixtures-for-ecto.html
defmodule Scripture.Fixtures do
  alias Scripture.Repo
  alias Scripture.User

  def persist_fixture(name) do
    Repo.insert!(build_fixture(name))
  end

  def build_fixture(:user) do
    User.admin_changeset(
      %User{},
      Map.merge(
        %{first_name: "Bernd",
          last_name: "Berndes",
          email: "bernd@example.com",
          role: "reader"},
        User.new_login_token))
  end

  def build_fixture(:admin) do
    User.admin_changeset(
      %User{},
      Map.merge(
        %{first_name: "Bernd",
          last_name: "Berndes",
          email: "bernd@example.com",
          role: "admin"},
        User.new_login_token))
  end
end
