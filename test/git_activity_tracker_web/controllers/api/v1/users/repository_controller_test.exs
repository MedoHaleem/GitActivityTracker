defmodule GitActivityTrackerWeb.Api.V1.RepositoryControllerTest do
  use GitActivityTrackerWeb.ConnCase, async: true
  describe "index" do
    test "lists all repositories", %{conn: conn} do
      conn = get(conn, Routes.api_v1_users_repository_path(conn, :index))
      assert json_response(conn, 200)[:data] == nil
    end
  end
end
