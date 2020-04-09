defmodule GitActivityTrackerWeb.Api.V1.ActivityController do
  use GitActivityTrackerWeb, :controller

  alias GitActivityTracker.Activity

  def create(conn, %{"pull_request" => %{"commits" => commits}, "repository" => repository}) do
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
