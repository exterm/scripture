# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :scripture, Scripture.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "HuFUBRZzCoCHoGLZSsJsrI8+LlImb+98pT+fntiEqld2C1o6eupVrEjuvaUAoQfg",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Scripture.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :rollbax,
  access_token: "75e197f9b08c4262a1ca766ff9821da6",
  environment: Mix.env

config :comeonin, Ecto.Password, Comeonin.Pbkdf2

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
