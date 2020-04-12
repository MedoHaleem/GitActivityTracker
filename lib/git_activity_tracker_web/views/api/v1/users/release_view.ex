defmodule GitActivityTrackerWeb.Api.V1.Users.ReleaseView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{release: release}) do
    render_one(release, __MODULE__, "release.json")
  end

  def render("index.json", %{releases: releases}) do
    render_many(releases, __MODULE__, "releases_list.json")
  end

  def render("release.json", %{release: release}) do
    %{
      tag_name: release.tag_name,
      released_at: release.released_at
    }
  end

  def render("releases_list.json", %{release: {_user_id, [%{user: user} | _tail] = data}}) do
    %{
      user: render_one(user, GitActivityTrackerWeb.Api.V1.UserView, "user.json"),
      releases: render_many(data, __MODULE__, "release_details.json")
    }
  end

  def render("release_details.json", %{release: %{commit_count: commit_count, schema: repo}}) do
    %{
      release: render_one(repo, __MODULE__, "release.json"),
      commit_count_by_user: commit_count
    }
  end
end
