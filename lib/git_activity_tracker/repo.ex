defmodule GitActivityTracker.Repo do
  use Ecto.Repo,
    otp_app: :git_activity_tracker,
    adapter: Ecto.Adapters.Postgres
end
