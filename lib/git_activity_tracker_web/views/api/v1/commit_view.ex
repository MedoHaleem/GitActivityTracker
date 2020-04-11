defmodule GitActivityTrackerWeb.Api.V1.CommitView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{commit: commit}) do
    render_one(commit, __MODULE__, "commit.json")
  end

  def render("index.json", %{commits: commits}) do
    render_many(commits, __MODULE__, "commit.json")
  end

  def render("commit.json", %{commit: commit}) do
    %{
      id: commit.id,
      sha: commit.sha,
      message: commit.message,
      date: commit.date
    }
  end
end
