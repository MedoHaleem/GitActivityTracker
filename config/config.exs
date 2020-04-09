# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :git_activity_tracker,
  ecto_repos: [GitActivityTracker.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :git_activity_tracker, GitActivityTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5+JBE7eZnjKx89w9ZoxLcw5ZilsrAt55H+jZVUWzQxVVOJnnIBKgp72S0xDsG2Nm",
  render_errors: [view: GitActivityTrackerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GitActivityTracker.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "kzBqiBUK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
