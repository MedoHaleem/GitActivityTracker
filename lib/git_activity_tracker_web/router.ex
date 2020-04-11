defmodule GitActivityTrackerWeb.Router do
  use GitActivityTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GitActivityTrackerWeb, as: :api do
    pipe_through :api

    scope "/v1", Api.V1, as: :v1 do
      resources "/activites", ActivityController, only: [:index, :create]
      resources "/users", UserController, only: [:show]
      resources "/repositories", RepositoryController, only: [:index]
    end
  end
end
