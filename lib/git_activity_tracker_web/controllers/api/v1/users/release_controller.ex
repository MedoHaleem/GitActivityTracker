defmodule GitActivityTrackerWeb.Api.V1.Users.ReleaseController do
  use GitActivityTrackerWeb, :controller
  alias GitActivityTracker.Activity

  def index(conn, _params) do
    releases = Activity.list_releases_commit_counts_by_user()
    render(conn, "index.json", releases: releases)
  end
end
