# for more functionality, read http://blog.danielberkompas.com/elixir/2015/07/16/fixtures-for-ecto.html
defmodule Scripture.Fixtures do
  alias Scripture.Repo
  alias Scripture.User

  def persist_fixture(name) do
    Repo.insert!(build_fixture(name))
  end

  def build_fixture(:user) do
    User.changeset(
      %User{first_name: "Bernd",
            last_name: "Berndes",
            email: "bernd@example.com"},
      User.new_login_token)
  end
end
