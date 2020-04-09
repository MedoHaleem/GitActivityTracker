defmodule GitActivityTrackerWeb.Api.V1.ActivityController do
  use GitActivityTrackerWeb, :controller

  alias GitActivityTracker.Activity
  alias GitActivityTracker.Authors

  def create(conn, %{"pull_request" => %{"commits" => commits}, "repository" => repository}) do
    save_commits_in_db(conn, commits, repository)
  end

  def create(conn, %{"commits" => commits, "repository" => repository}) do
    save_commits_in_db(conn, commits, repository)
  end

  defp save_commits_in_db(conn, commits, repository) do
    with commit_repository <-
           Activity.find_or_create_repository(repository),
         activites <- Activity.save_commits(commit_repository, commits) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_activity_path(conn, :index, activites))
      |> render("index.json", activites: activites)
    end
  end
end
