defmodule GitActivityTracker.ActivityTest do
  use GitActivityTracker.DataCase

  alias GitActivityTracker.Activity

  describe "repositories" do
    alias GitActivityTracker.Activity.Repository

    @valid_attrs %{name: "some name", uuid: 42}
    @update_attrs %{name: "some updated name", uuid: 43}
    @invalid_attrs %{name: nil, uuid: nil}


    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert Activity.list_repositories() == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Activity.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = Activity.create_repository(@valid_attrs)
      assert repository.name == "some name"
      assert repository.uuid == 42
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activity.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{} = repository} = Activity.update_repository(repository, @update_attrs)
      assert repository.name == "some updated name"
      assert repository.uuid == 43
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Activity.update_repository(repository, @invalid_attrs)
      assert repository == Activity.get_repository!(repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = Activity.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> Activity.get_repository!(repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Activity.change_repository(repository)
    end
  end

  describe "releases" do
    alias GitActivityTracker.Activity.Release

    @valid_attrs %{released_at: ~D[2010-04-17], tag_name: "some tag_name", uuid: 42}
    @update_attrs %{released_at: ~D[2011-05-18], tag_name: "some updated tag_name", uuid: 43}
    @invalid_attrs %{released_at: nil, tag_name: nil, uuid: nil}



    test "list_releases/0 returns all releases" do
      owner = user_fixture()
      %Release{id: id1} = release_fixture(owner)
      assert [%Release{id: ^id1}] = Activity.list_releases()
    end

    test "get_release!/1 returns the release with given id" do
      owner = user_fixture()
      %Release{id: id} = release_fixture(owner)
      assert %Release{id: ^id} = Activity.get_release!(id)
    end

    test "create_release/1 with valid data creates a release" do
      owner = user_fixture()
      assert {:ok, %Release{} = release} = Activity.create_release(owner, @valid_attrs)
      assert release.released_at == ~D[2010-04-17]
      assert release.tag_name == "some tag_name"
      assert release.uuid == 42
    end

    test "create_release/1 with invalid data returns error changeset" do
      owner = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Activity.create_release(owner, @invalid_attrs)
    end

    test "update_release/2 with valid data updates the release" do
      owner = user_fixture()
      release = release_fixture(owner)
      assert {:ok, %Release{} = release} = Activity.update_release(release, @update_attrs)
      assert release.released_at == ~D[2011-05-18]
      assert release.tag_name == "some updated tag_name"
      assert release.uuid == 43
    end

    test "update_release/2 with invalid data returns error changeset" do
      owner = user_fixture()
      %Release{id: id} = release = release_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Activity.update_release(release, @invalid_attrs)
      assert %Release{id: ^id} = Activity.get_release!(release.id)
    end

    test "delete_release/1 deletes the release" do
      owner = user_fixture()
      release = release_fixture(owner)
      assert {:ok, %Release{}} = Activity.delete_release(release)
      assert_raise Ecto.NoResultsError, fn -> Activity.get_release!(release.id) end
    end

    test "change_release/1 returns a release changeset" do
      owner = user_fixture()
      release = release_fixture(owner)
      assert %Ecto.Changeset{} = Activity.change_release(release)
    end
  end
end
