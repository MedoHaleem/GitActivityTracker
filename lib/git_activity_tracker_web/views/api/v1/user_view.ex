defmodule GitActivityTrackerWeb.Api.V1.UserView do
  use GitActivityTrackerWeb, :view

  def render("show.json", %{user: user}) do
    %{
      data: render_one(user, __MODULE__, "user.json")
    }
  end

  def render("index.json", %{users: users}) do
    %{
      data: render_many(users, __MODULE__, "user.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        uuid: user.uuid,
        username: user.username,
        email: user.email
      }
    }
  end
end
