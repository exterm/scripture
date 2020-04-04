# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :scripture,
  ecto_repos: [Scripture.Repo]

# Configures the endpoint
config :scripture, ScriptureWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "br8vcYwpJaLZ/KgiwRcdbg+zojNuvgALrOzZyn0/0NGk0thPvo9QQv80Cbn9fkW8",
  render_errors: [view: ScriptureWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Scripture.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "KP5SwYXt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
