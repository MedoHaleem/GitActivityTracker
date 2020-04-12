defmodule GitActivityTrackerWeb.Api.V1.RepositoryView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{repository: repository}) do
    render_one(repository, __MODULE__, "repository.json")
  end

  def render("index.json", %{repositories: repositories}) do
    render_many(repositories, __MODULE__, "repository.json")
  end




  def render("repository.json", %{repository: repository}) do
    %{
      id: repository.uuid,
      name: repository.name
    }
  end
end
