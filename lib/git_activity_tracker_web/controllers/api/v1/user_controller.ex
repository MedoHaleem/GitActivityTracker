defmodule GitActivityTrackerWeb.Api.V1.UserController do
  use GitActivityTrackerWeb, :controller
  alias GitActivityTracker.Authors

  def show(conn, %{"id" => id}) do
    user = Authors.get_user!(id)
    render(conn, "show.json", user: user)
  end
end
