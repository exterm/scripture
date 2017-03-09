# for more functionality, read http://blog.danielberkompas.com/elixir/2015/07/16/fixtures-for-ecto.html
defmodule Scripture.Fixtures do
  alias Scripture.Repo

  alias Scripture.{User, Article, Comment}

  def build_fixture(module) do
    build_fixture(module, %{})
  end
  def build_fixture(module, key) when is_atom(key) do
    build_fixture(module, key, %{})
  end
  def build_fixture(module, params) do
    build_fixture(module, module, params)
  end
  def build_fixture(module, fixture_name, params) do
    changeset = fixture_changeset(module, Map.merge(fixture_defaults(fixture_name), params))
    Map.merge(module.__struct__, changeset.changes)
  end

  def persist_fixture(module) do
    persist_fixture(module, %{})
  end
  def persist_fixture(module, key) when is_atom(key) do
    persist_fixture(module, key, %{})
  end
  def persist_fixture(module, params) do
    persist_fixture(module, module, params)
  end
  def persist_fixture(module, fixture_name, params) do
    changeset = fixture_changeset(module, Map.merge(fixture_defaults(fixture_name), params))
    Repo.insert!(changeset)
  end

  def fixture_defaults(User) do
    basic_defaults = %{first_name: "Bernd",
                       last_name: "Berndes",
                       email: "bernd@example.com",
                       role: "reader",
                       group: "acquaintances"}
    Map.merge(basic_defaults, User.new_login_token)
  end
  def fixture_defaults(:admin) do
    basic_defaults = %{first_name: "Philip",
      last_name: "Müller",
      email: "philip@example.com",
      role: "admin",
      group: "close family"}
    Map.merge(basic_defaults, User.new_login_token)
  end
  def fixture_defaults(Article) do
    %{title: "Die 33 besten Artikel-Headlines",
      content: "Buzzfeed hat angerufen.",
      published: true}
  end
  def fixture_defaults(Comment) do
    %{message: "Best article evar",
      user_id: 1,
      article_id: 1}
  end

  # private

  defp fixture_changeset(module, params) do
    case module do
      User -> User.admin_changeset(module.__struct__, params)
      _    -> module.changeset(module.__struct__, params)
    end
  end
end
