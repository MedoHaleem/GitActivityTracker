defmodule GitActivityTrackerWeb.Api.V1.ReleaseView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{release: release}) do
    %{
      data: render_one(release, __MODULE__, "release.json")
    }
  end

  def render("index.json", %{releases: releases}) do
    %{
      data: render_many(releases, __MODULE__, "releases.json")
    }
  end

  def render("release.json", %{release: release}) do
    %{
      data: %{
        tag_name: release.tag_name,
        released_at: release.released_at
      }
    }
  end
end
