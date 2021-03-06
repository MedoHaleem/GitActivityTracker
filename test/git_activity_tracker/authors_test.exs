defmodule GitActivityTracker.AuthorsTest do
  use GitActivityTracker.DataCase, async: true

  alias GitActivityTracker.Authors

  describe "users" do
    alias GitActivityTracker.Authors.User

    @valid_attrs %{email: "test@test.com", username: "some username", uuid: 42}
    @update_attrs %{email: "test_updated@test.com", username: "some updated username", uuid: 43}
    @invalid_attrs %{email: nil, username: nil, uuid: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Authors.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      %User{id: id} = user_fixture()
      assert [%User{id: ^id}] = Authors.list_users()
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Authors.create_user(@valid_attrs)
      assert user.email == "test@test.com"
      assert user.username == "some username"
      assert user.uuid == 42
    end

    test "find_or_create_author/1 returns the new repository that wasn't created before" do
      assert {:ok, %User{} = author} = Authors.find_or_create_author(@valid_attrs)
      assert author.username == "some username"
      assert author.uuid == 42
    end

    test "find_or_create_author/1 returns the repository that already exists" do
      repository_fixture(@valid_attrs)
      assert {:ok, %User{} = author} = Authors.find_or_create_author(@valid_attrs)
      assert author.username == "some username"
      assert author.uuid == 42
    end


    test "find_or_create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.find_or_create_author(@invalid_attrs)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Authors.update_user(user, @update_attrs)
      assert user.email == "test_updated@test.com"
      assert user.username == "some updated username"
      assert user.uuid == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      %User{id: id} = user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Authors.update_user(user, @invalid_attrs)
      assert [%User{id: ^id}] = Authors.list_users()
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Authors.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Authors.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Authors.change_user(user)
    end

    test "does not accpet invalid email" do
      attrs = Map.put(@valid_attrs, :email, "some email")
      {:error, changeset} = Authors.create_user(attrs)

      assert %{email: ["has invalid format"]} = errors_on(changeset)
      assert Authors.list_users() == []
    end
  end
end
