defmodule Scripture.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      use Scripture.AcceptanceHelper

      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import Scripture.Router.Helpers
      import Scripture.Fixtures
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Scripture.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Scripture.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Scripture.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
