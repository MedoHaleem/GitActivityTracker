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
    attrs = Enum.into(attrs, %{date: ~D[2010-04-17], message: "FEAT: Support Android 8.1 devices \n\nRef: #sp-131", sha: "ASDADDFSFHGHJGHJHGJK"})
    {:ok, commit} = Activity.create_commit(repository, user, attrs)

    commit
  end

  def ticket_fixture(commit, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{name: "sp-111"})
    {:ok, ticket} = Activity.create_ticket(commit, attrs)

    ticket
  end
end
