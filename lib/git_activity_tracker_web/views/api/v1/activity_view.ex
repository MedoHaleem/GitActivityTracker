defmodule GitActivityTrackerWeb.Api.V1.ActivityView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{activity: activity}) do
    %{
      data: render_one(activity, __MODULE__, "activity.json")
    }
  end

  def render("index.json", %{activites: activites}) do
    %{
      data: render_many(activites, __MODULE__, "activity.json")
    }
  end

  def render("index_with_release.json", %{activites: activites}) do
    IO.inspect activites
    %{
      data: render_many(activites, __MODULE__, "release_activity.json")
    }
  end



  def render("activity.json", %{activity: activity}) do
    case activity do
      %GitActivityTracker.Activity.Commit{} ->
      %{
        data: %{
          id: activity.id,
          date: activity.date,
          user: render_one(activity.user, GitActivityTrackerWeb.Api.V1.UserView, "user.json"),
          repository: render_one(activity.repository, GitActivityTrackerWeb.Api.V1.RepositoryView, "repository.json")
        }
      }
    %Ecto.Changeset{} ->
      %{
        data: render_one(activity, GitActivityTrackerWeb.ChangesetView, "error.json")
      }
    end
  end

  def render("release_activity.json", %{activity: activity}) do
    IO.puts "======================================================================================================================"
    IO.inspect activity
    case activity do
      %GitActivityTracker.Activity.Commit{} ->
      %{
        id: activity.id,
        date: activity.date,
        user: render_one(activity.user, GitActivityTrackerWeb.Api.V1.UserView, "user.json"),
        repository: render_one(activity.repository, GitActivityTrackerWeb.Api.V1.RepositoryView, "repository.json"),
        release: render_one(activity.release, GitActivityTrackerWeb.Api.V1.ReleaseView, "release.json")
      }
    %Ecto.Changeset{} ->
      %{
        data: render_one(activity, GitAcitvityTrackerWeb.ChangesetView, "error.json")
      }
    end
  end


end
