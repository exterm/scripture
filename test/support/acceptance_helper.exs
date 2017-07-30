defmodule Scripture.AcceptanceHelper do
  use ExUnit.CaseTemplate
  use Wallaby.DSL

  defmacro __using__(_) do
    quote do
      import Scripture.AcceptanceHelper
    end
  end

  def log_in_as(session, user) do
    body = session
      |> visit("/?login_token=#{user.login_token}")
      |> find(Query.css("body"))

    assert current_path(body) == "/"
    assert_text(body, user.first_name <> " " <> user.last_name)

    session
  end
end
