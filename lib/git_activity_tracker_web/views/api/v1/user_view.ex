defmodule GitActivityTrackerWeb.Api.V1.UserView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{user: user}) do
    render_one(user, __MODULE__, "user_details.json")
  end

  def render("user_details.json", %{user: user}) do
    %{
      user: render_one(user, __MODULE__, "user.json"),
      commits: render_many(user.commits, GitActivityTrackerWeb.Api.V1.CommitView, "commit.json"),
      commits_count: length(user.commits),
      release:
        render_many(user.releases, GitActivityTrackerWeb.Api.V1.ReleaseView, "release.json"),
      release_count: length(user.releases)
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      uuid: user.uuid,
      username: user.username,
      email: user.email
    }
  end
end
