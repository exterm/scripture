# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :scripture,
  ecto_repos: [Scripture.Repo]

# Configures the endpoint
config :scripture, Scripture.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+WVCHcVWumvs/alnkO1atW8S/kVrpe8jXr3QyFtWlvJVW378LIPL6d+mfkeq922K",
  render_errors: [view: Scripture.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Scripture.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :rollbax,
  access_token: "75e197f9b08c4262a1ca766ff9821da6",
  environment: Mix.env
