defmodule GitActivityTracker.Authors do
  @moduledoc """
  The Authors context.
  """

  import Ecto.Query, warn: false
  alias GitActivityTracker.Repo

  alias GitActivityTracker.Authors.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end



  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:commits) |> Repo.preload(:releases)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def find_or_create_author(%{"email" => email, "id" => uuid, "name" => name}) do
    user = %{
      email: email,
      uuid: uuid,
      username: name
    }
    find_or_create_author(user)
  end

  def find_or_create_author(%{uuid: nil} = author), do: {:error, %User{} |> User.changeset(author)}

  def find_or_create_author(%{uuid: uuid} = author) do
    case Repo.get_by(User, %{uuid: uuid}) do
      nil  -> %User{}
      user -> user
    end
    |> User.changeset(author)
    |> Repo.insert_or_update
  end
end
