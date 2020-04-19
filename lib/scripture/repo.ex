defmodule Scripture.Repo do
  use Ecto.Repo,
    otp_app: :scripture,
    adapter: Ecto.Adapters.Postgres
end
