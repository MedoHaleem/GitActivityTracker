defmodule GitActivityTrackerWeb.Api.V1.RepositoryController do
  use GitActivityTrackerWeb, :controller
  alias GitActivityTracker.Activity

  def index(conn, _params) do
    repositories = Activity.list_repo_commit_counts_by_user()
    render(conn, "index.json", repositories: repositories)
  end
end
