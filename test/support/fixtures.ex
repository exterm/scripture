# for more functionality, read http://blog.danielberkompas.com/elixir/2015/07/16/fixtures-for-ecto.html
defmodule Scripture.Fixtures do
  alias Scripture.Repo

  alias Scripture.User
  alias Scripture.Article

  def persist_fixture(name, attributes \\ %{}) do
    Repo.insert!(build_fixture(name, attributes))
  end

  def build_fixture(name, attributes \\ %{})

  def build_fixture(:user, attributes) do
    basic_defaults = %{first_name: "Bernd",
                       last_name: "Berndes",
                       email: "bernd@example.com",
                       role: "reader",
                       group: "acquaintances"}
    User.admin_changeset(
      %User{},
      basic_defaults
      |> Map.merge(User.new_login_token)
      |> Map.merge(attributes))
  end

  def build_fixture(:admin, attributes) do
    basic_defaults = %{first_name: "Philip",
                       last_name: "Müller",
                       email: "philip@example.com",
                       role: "admin",
                       group: "close family"}
    User.admin_changeset(
      %User{},
      basic_defaults
      |> Map.merge(User.new_login_token)
      |> Map.merge(attributes))
  end

  def build_fixture(:article, attributes) do
    defaults = %{title: "Die 33 besten Artikel-Headlines",
                 content: "Buzzfeed hat angerufen.",
                 published: true}
    Article.changeset(
      %Article{},
      defaults
      |> Map.merge(attributes))
  end
end
