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

  def repository_fixture(attrs \\ %{}) do
    {:ok, repository} =
      attrs
      |> Enum.into(%{name: "some name", uuid: 42})
      |> Activity.create_repository()

    repository
  end

  def release_fixture(%Authors.User{} = user, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{released_at: ~D[2010-04-17], tag_name: "some tag_name", uuid: 42})
    {:ok, release} = Activity.create_release(user, attrs)
    release
  end

  def commit_fixture(%Activity.Repository{} = repository, %Authors.User{} = user, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{date: ~D[2010-04-17], message: "some message", sha: "ASDADDFSFHGHJGHJHGJK"})
    {:ok, commit} = Activity.create_commit(repository, user, attrs)

    commit
  end
end
