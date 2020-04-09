defmodule GitActivityTrackerWeb.Api.V1.RepositoryView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{repository: repository}) do
    %{
      data: render_one(repository, __MODULE__, "repository.json")
    }
  end

  def render("index.json", %{repositories: repositories}) do
    %{
      data: render_many(repositories, __MODULE__, "repositories.json")
    }
  end

  def render("repository.json", %{repository: repository}) do
    %{
      data: %{
        id: repository.uuid,
        name: repository.name
      }
    }
  end
end
