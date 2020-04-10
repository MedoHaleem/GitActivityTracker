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

  def create(conn, %{
        "release" => release,
        "released_at" => released_at,
        "repository" => repository
      }) do
    with releaser <- Authors.find_or_create_author(release["author"]),
         {:ok, created_release} <-
           Activity.create_release(releaser, %{
             uuid: release["id"],
             tag_name: release["tag_name"],
             released_at: released_at
           }),
         release_repository <-
           Activity.find_or_create_repository(repository),
         {:ok, release_commits} <-
           Activity.save_commits_included_in_the_release(
             release_repository,
             created_release,
             release["commits"]
           ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_activity_path(conn, :index, release_commits))
      |> render("index_with_release.json", activites: Map.values(release_commits))
    else
      {:error, _, changeset, _} ->
        conn
        |> put_status(:bad_request)
        |> render(GitActivityTrackerWeb.ChangesetView, "error.json", changeset: changeset)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(GitActivityTrackerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp save_commits_in_db(conn, commits, repository) do
    with commit_repository <-
           Activity.find_or_create_repository(repository),
         {:ok, activites} <- Activity.save_commits(commit_repository, commits) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_activity_path(conn, :index, activites))
      |> render("index.json", activites: Map.values(activites))
    else
      {:error, _, changeset, _} ->
        conn
        |> put_status(:bad_request)
        |> render(GitActivityTrackerWeb.ChangesetView, "error.json", changeset: changeset)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(GitActivityTrackerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
