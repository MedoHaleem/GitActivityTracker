defmodule GitActivityTracker.ActivityTest do
  use GitActivityTracker.DataCase, async: true

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

    test "list_repo_commit_counts_by_user/0 returns all counts of commit for each repo grouped by user" do
      repository = repository_fixture()
      owner = user_fixture()
      commit_fixture(repository, owner)
      assert Activity.list_repo_commit_counts_by_user() == %{owner.id => [%{commit_count: 1, schema: repository, user: owner}]}
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Activity.get_repository!(repository.id) == repository
    end

    test "find_or_create_repository/1 returns the new repository that wasn't created before" do
      assert {:ok, %Repository{} = repository} = Activity.find_or_create_repository(@valid_attrs)
      assert repository.name == "some name"
      assert repository.uuid == 42
    end

    test "find_or_create_repository/1 returns the repository that already exists" do
      repository_fixture(@valid_attrs)
      assert {:ok, %Repository{} = repository} = Activity.find_or_create_repository(@valid_attrs)
      assert repository.name == "some name"
      assert repository.uuid == 42
    end

    test "find_or_create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activity.find_or_create_repository(@invalid_attrs)
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

      assert {:ok, %Repository{} = repository} =
               Activity.update_repository(repository, @update_attrs)

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

    test "list_releases_commit_counts_by_user/0 returns all counts of commit for each release grouped by user" do
      repository = repository_fixture()
      owner = user_fixture()
      release = release_fixture(owner)
      release = Activity.get_release!(release.id)
      Activity.create_commit_with_assoc_release(repository, owner, release, %{date: ~D[2010-04-17], message: "some message", sha: "some sha"})
      assert Activity.list_releases_commit_counts_by_user() == %{owner.id => [%{commit_count: 1, schema: release, user: owner}]}
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

  describe "commits" do
    alias GitActivityTracker.Activity.Commit

    @valid_attrs %{date: ~D[2010-04-17], message: "some message", sha: "some sha"}
    @update_attrs %{
      date: ~D[2011-05-18],
      message: "some updated message",
      sha: "some updated sha"
    }
    @invalid_attrs %{date: nil, message: nil, sha: nil}

    test "list_commits/0 returns all commits" do
      owner = user_fixture()
      repo = repository_fixture()
      %Commit{id: id1} = commit_fixture(repo, owner)
      assert [%Commit{id: ^id1}] = Activity.list_commits()
    end

    test "get_commit!/1 returns the commit with given id" do
      owner = user_fixture()
      repo = repository_fixture()
      %Commit{id: id} = commit_fixture(repo, owner)
      assert %Commit{id: ^id} = Activity.get_commit!(id)
    end

    test "create_commit/2 with valid data creates a commit" do
      owner = user_fixture()
      repo = repository_fixture()
      assert {:ok, %Commit{} = commit} = Activity.create_commit(repo, owner, @valid_attrs)
      assert commit.date == ~D[2010-04-17]
      assert commit.message == "some message"
      assert commit.sha == "some sha"
    end

    test "create_commit/2 with invalid data returns error changeset" do
      owner = user_fixture()
      repo = repository_fixture()
      assert {:error, %Ecto.Changeset{}} = Activity.create_commit(repo, owner, @invalid_attrs)
    end

    test "create_commit_with_assoc_release/3 with valid data creates a commit" do
      owner = user_fixture()
      repo = repository_fixture()
      release = release_fixture(owner)
      assert {:ok, %Commit{} = commit} = Activity.create_commit_with_assoc_release(repo, owner, release,@valid_attrs)
      assert commit.date == ~D[2010-04-17]
      assert commit.message == "some message"
      assert commit.sha == "some sha"
    end

    test "create_commit_with_assoc_release/3 with invalid data returns error changeset" do
      owner = user_fixture()
      repo = repository_fixture()
      release = release_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Activity.create_commit_with_assoc_release(repo, owner, release, @invalid_attrs)
    end

    test "save_commits/2 with valid data creates list of commits" do
      repo = repository_fixture()
      commits = [
        %{
          "author" => %{
            "email" => "ahmed@suitepad.de",
            "id" => 21431007,
            "name" => "ahmed"
          },
          "date" => "2018-05-27T16:00:49Z",
          "message" => "some message",
          "sha" => "some sha"
        }]
      {:ok, result} = Activity.save_commits(repo,commits)
      [commit] = Map.values(result)
      assert commit.date == ~D[2018-05-27]
      assert commit.message == "some message"
      assert commit.sha == "some sha"
    end


    test "save_commits/2 with invalid return changeset" do
      repo = repository_fixture()
      commits = [
        %{
          "author" => %{
            "email" => "ahmed@suitepad.de",
            "id" => 21431007,
            "name" => "ahmed"
          },
          "date" => nil,
          "message" => nil,
          "sha" => nil
        }]
        assert {:error, _, changeset, _} = Activity.save_commits(repo,commits)
    end

    test "save_commits_included_in_the_release/3 with valid data creates list of commits" do
      repo = repository_fixture()
      owner = user_fixture()
      release = release_fixture(owner)
      commits = [
        %{
          "author" => %{
            "email" => "ahmed@suitepad.de",
            "id" => 21431007,
            "name" => "ahmed"
          },
          "date" => "2018-05-27T16:00:49Z",
          "message" => "some message",
          "sha" => "some sha"
        }]
      {:ok, result} = Activity.save_commits_included_in_the_release(repo, release, commits)
      [commit] = Map.values(result)
      assert commit.date == ~D[2018-05-27]
      assert commit.message == "some message"
      assert commit.sha == "some sha"
    end


    test "save_commits_included_in_the_release/3 with invalid return changeset" do
      repo = repository_fixture()
      owner = user_fixture()
      release = release_fixture(owner)
      commits = [
        %{
          "author" => %{
            "email" => "ahmed@suitepad.de",
            "id" => 21431007,
            "name" => "ahmed"
          },
          "date" => nil,
          "message" => nil,
          "sha" => nil
        }]
        assert {:error, _, changeset, _} = Activity.save_commits_included_in_the_release(repo, release, commits)
    end



    test "update_commit/2 with valid data updates the commit" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      assert {:ok, %Commit{} = commit} = Activity.update_commit(commit, @update_attrs)
      assert commit.date == ~D[2011-05-18]
      assert commit.message == "some updated message"
      assert commit.sha == "some updated sha"
    end

    test "update_commit/2 with invalid data returns error changeset" do
      owner = user_fixture()
      repo = repository_fixture()
      %Commit{id: id} = commit = commit_fixture(repo, owner)
      assert {:error, %Ecto.Changeset{}} = Activity.update_commit(commit, @invalid_attrs)
      assert %Commit{id: ^id} = Activity.get_commit!(commit.id)
    end

    test "delete_commit/1 deletes the commit" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      assert {:ok, %Commit{}} = Activity.delete_commit(commit)
      assert_raise Ecto.NoResultsError, fn -> Activity.get_commit!(commit.id) end
    end

    test "change_commit/1 returns a commit changeset" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      assert %Ecto.Changeset{} = Activity.change_commit(commit)
    end
  end

  describe "tickets" do
    alias GitActivityTracker.Activity.Ticket

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}



    test "list_tickets/0 returns all tickets" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      %Ticket{id: id} = ticket_fixture(commit)
      assert [%Ticket{id: ^id}] = Activity.list_tickets()
    end

    test "get_ticket!/1 returns the ticket with given id" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      %Ticket{id: id} = ticket = ticket_fixture(commit)
      assert %Ticket{id: ^id} = Activity.get_ticket!(ticket.id)
    end

    test "create_ticket/1 with valid data creates a ticket" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      assert {:ok, %Ticket{} = ticket} = Activity.create_ticket(commit, @valid_attrs)
      assert ticket.name == "some name"
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      assert {:error, %Ecto.Changeset{}} = Activity.create_ticket(commit, @invalid_attrs)
    end

    test "save_tickets/2 with valid data creates list of tickets" do
      repo = repository_fixture()
      owner = user_fixture()
      commit = commit_fixture(repo, owner)
      tickets = [
        %{
          id: "sp-111"
        }
        ]
      {:ok, result} = Activity.save_tickets(commit, tickets)
      [ticket] = Map.values(result)
      assert ticket.name == "sp-111"
    end


    test "save_tickets/2 with invalid return changeset" do
      repo = repository_fixture()
      owner = user_fixture()
      commit = commit_fixture(repo, owner)
      tickets = [
        %{
          id: nil
        }
        ]
        assert {:error, _, changeset, _} = Activity.save_tickets(commit,tickets)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      ticket = ticket_fixture(commit)
      assert {:ok, %Ticket{} = ticket} = Activity.update_ticket(ticket, @update_attrs)
      assert ticket.name == "some updated name"
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      %Ticket{id: id} = ticket = ticket_fixture(commit)
      assert {:error, %Ecto.Changeset{}} = Activity.update_ticket(ticket, @invalid_attrs)
      assert %Ticket{id: ^id} = Activity.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      ticket = ticket_fixture(commit)
      assert {:ok, %Ticket{}} = Activity.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Activity.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      owner = user_fixture()
      repo = repository_fixture()
      commit = commit_fixture(repo, owner)
      ticket = ticket_fixture(commit)
      assert %Ecto.Changeset{} = Activity.change_ticket(ticket)
    end
  end
end
