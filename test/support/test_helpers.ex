defmodule GitActivityTracker.TestHelpers do
  alias GitActivityTracker.{
    Authors,
    Activity
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: "Test",
        email: "test#{System.unique_integer([:positive])}@test.com",
        uuid: System.unique_integer([:positive])
      })
      |> Authors.create_user()

    user
  end
end
