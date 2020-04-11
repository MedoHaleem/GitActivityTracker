defmodule GitActivityTrackerWeb.Api.V1.RepositoryView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{repository: repository}) do
    render_one(repository, __MODULE__, "repository.json")
  end

  def render("index.json", %{repositories: repositories}) do
    render_many(repositories, __MODULE__, "repos_list.json")
  end


  def render("repos_list.json", %{repository: {_user_id, [%{user: user} | _tail] = data}}) do
    %{
      user: render_one(user, GitActivityTrackerWeb.Api.V1.UserView, "user.json"),
      repos: render_many(data, __MODULE__, "repo_details.json")
    }
  end

  def render("repository.json", %{repository: repository}) do
    %{
      id: repository.uuid,
      name: repository.name
    }
  end

  def render("repo_details.json", %{repository: %{commit_count: commit_count, schema: repo}}) do
    %{
      repository: render_one(repo, __MODULE__, "repository.json"),
      commit_count_by_user: commit_count
    }
  end
end
