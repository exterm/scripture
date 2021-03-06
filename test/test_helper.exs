Code.require_file("support/session_helper.exs", __DIR__)
Code.require_file("support/acceptance_helper.exs", __DIR__)

ExUnit.start

{:ok, _} = Application.ensure_all_started(:wallaby)

Ecto.Adapters.SQL.Sandbox.mode(Scripture.Repo, :manual)

Application.put_env(:wallaby, :base_url, Scripture.Endpoint.url)
