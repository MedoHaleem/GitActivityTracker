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



  def render("activity.json", %{activity: activity}) do
    IO.inspect activity
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


end
