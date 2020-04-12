use Mix.Config

# Configure your database
config :git_activity_tracker, GitActivityTracker.Repo,
  username: "medo",
  password: "password",
  database: "git_activity_tracker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :git_activity_tracker, GitActivityTrackerWeb.Endpoint,
  http: [port: 4002],
  server: false

  config :git_activity_tracker, :ticket_service_host, "https://webhook.site/3d2689e1-3812-4466-afd7-77f15cdd560c"

# Print only warnings and errors during test
config :logger, level: :warn
