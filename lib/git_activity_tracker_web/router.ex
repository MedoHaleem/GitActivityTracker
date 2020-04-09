defmodule GitActivityTrackerWeb.Router do
  use GitActivityTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GitActivityTrackerWeb do
    pipe_through :api
  end
end
