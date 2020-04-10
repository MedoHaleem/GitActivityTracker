defmodule GitActivityTrackerWeb.Api.V1.ActivityController do
  use GitActivityTrackerWeb, :controller

  alias GitActivityTracker.Activity
  alias GitActivityTracker.Authors
  alias GitActivityTracker.Parser

  def create(conn, %{"pull_request" => %{"commits" => commits}, "repository" => repository}) do
    case save_commits_in_db(commits, repository) do
      {:ok, activites} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.api_v1_activity_path(conn, :index, activites))
        |> render("index.json", activites: activites)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(GitActivityTrackerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def create(conn, %{"commits" => commits, "repository" => repository}) do
    case save_commits_in_db(commits, repository) do
      {:ok, activites} ->
        # Update the Ticket Tracking Cloud Service
        Enum.map(activites, fn commit ->
          Parser.parse_message_and_update_ready_release_ticket(commit)
        end)

        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.api_v1_activity_path(conn, :index, activites))
        |> render("index.json", activites: activites)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(GitActivityTrackerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def create(conn, %{
        "release" => release,
        "released_at" => released_at,
        "repository" => repository
      }) do
    case save_commits_with_assoc_release(repository, release, released_at) do
      {:ok, activites, created_release} ->
        # Update the Ticket Tracking Cloud Service
        Enum.map(activites, fn commit ->
          Parser.parse_message_and_update_released_ticket(created_release, commit)
        end)

        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.api_v1_activity_path(conn, :index, activites))
        |> render("index_with_release.json", activites: activites)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(GitActivityTrackerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp save_commits_in_db(commits, repository) do
    with commit_repository <-
           Activity.find_or_create_repository(repository),
         {:ok, activites} <- Activity.save_commits(commit_repository, commits) do
      activites = Map.values(activites)
      {:ok, activites}
    else
      {:error, _, changeset, _} -> {:error, changeset}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp save_commits_with_assoc_release(repository, release, released_at) do
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
      {:ok, Map.values(release_commits), created_release}
    else
      {:error, _, changeset, _} -> {:error, changeset}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
