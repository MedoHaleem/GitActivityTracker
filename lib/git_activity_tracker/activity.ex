defmodule GitActivityTracker.Activity do
  @moduledoc """
  The Activity context.
  """

  import Ecto.Query, warn: false
  alias GitActivityTracker.Repo
  alias Ecto.Multi

  alias GitActivityTracker.Authors
  alias GitActivityTracker.Activity.Repository
  alias GitActivityTracker.Activity.Release

  @doc """
  Returns the list of repositories.

  ## Examples

      iex> list_repositories()
      [%Repository{}, ...]

  """
  def list_repositories do
    Repo.all(Repository)
  end

  @doc """
  Gets a single repository.

  Raises `Ecto.NoResultsError` if the Repository does not exist.

  ## Examples

      iex> get_repository!(123)
      %Repository{}

      iex> get_repository!(456)
      ** (Ecto.NoResultsError)

  """
  def get_repository!(id), do: Repo.get!(Repository, id)

  @doc """
  Creates a repository.

  ## Examples

      iex> create_repository(%{field: value})
      {:ok, %Repository{}}

      iex> create_repository(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repository(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  # def find_or_create_repository(repo_params) do
  #   repository =

  #   repository
  # end

  def find_or_create_repository(%{"id" => uuid, "name" => name}) do
    repo_params = %{uuid: uuid, name: name}
    find_or_create_repository(repo_params)
  end

  def find_or_create_repository(repo_params) do
    repository =
      case Repo.get_by(Repository, %{uuid: repo_params.uuid, name: repo_params.name}) do
        nil ->
          %Repository{} |> Repository.changeset(repo_params) |> Repo.insert!()

        repository ->
          repository
      end

    repository
  end

  def list_schema_commit_counts(schema) do
    from(s in schema,
      join: c in assoc(s, :commits),
      join: u in assoc(c, :user),
      group_by: [s.id, u.id],
      select: %{schema: s, user: u, commit_count: count(c.id)}
    )
    |> Repo.all()
  end

  def list_repo_commit_counts_by_user() do
    list_schema_commit_counts(Repository)
    |> Enum.group_by(fn %{user: user} -> user.id end)
  end

  def list_releases_commit_counts_by_user() do
    list_schema_commit_counts(Release)
    |> Enum.group_by(fn %{user: user} -> user.id end)
  end


  @doc """
  Updates a repository.

  ## Examples

      iex> update_repository(repository, %{field: new_value})
      {:ok, %Repository{}}

      iex> update_repository(repository, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_repository(%Repository{} = repository, attrs) do
    repository
    |> Repository.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a repository.

  ## Examples

      iex> delete_repository(repository)
      {:ok, %Repository{}}

      iex> delete_repository(repository)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repository(%Repository{} = repository) do
    Repo.delete(repository)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking repository changes.

  ## Examples

      iex> change_repository(repository)
      %Ecto.Changeset{source: %Repository{}}

  """
  def change_repository(%Repository{} = repository) do
    Repository.changeset(repository, %{})
  end



  @doc """
  Returns the list of releases.

  ## Examples

      iex> list_releases()
      [%Release{}, ...]

  """
  def list_releases do
    Repo.all(Release)
  end

  @doc """
  Gets a single release.

  Raises `Ecto.NoResultsError` if the Release does not exist.

  ## Examples

      iex> get_release!(123)
      %Release{}

      iex> get_release!(456)
      ** (Ecto.NoResultsError)

  """
  def get_release!(id), do: Repo.get!(Release, id)

  def create_release(%Authors.User{} = user, attrs \\ %{}) do
    %Release{}
    |> Release.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a release.

  ## Examples

      iex> update_release(release, %{field: new_value})
      {:ok, %Release{}}

      iex> update_release(release, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_release(%Release{} = release, attrs) do
    release
    |> Release.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a release.

  ## Examples

      iex> delete_release(release)
      {:ok, %Release{}}

      iex> delete_release(release)
      {:error, %Ecto.Changeset{}}

  """
  def delete_release(%Release{} = release) do
    Repo.delete(release)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking release changes.

  ## Examples

      iex> change_release(release)
      %Ecto.Changeset{source: %Release{}}

  """
  def change_release(%Release{} = release) do
    Release.changeset(release, %{})
  end

  alias GitActivityTracker.Activity.Commit

  @doc """
  Returns the list of commits.

  ## Examples

      iex> list_commits()
      [%Commit{}, ...]

  """
  def list_commits do
    Repo.all(Commit)
  end

  @doc """
  Gets a single commit.

  Raises `Ecto.NoResultsError` if the Commit does not exist.

  ## Examples

      iex> get_commit!(123)
      %Commit{}

      iex> get_commit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_commit!(id), do: Repo.get!(Commit, id)

  @doc """
  Creates a commit.

  ## Examples

      iex> create_commit(%{field: value})
      {:ok, %Commit{}}

      iex> create_commit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_commit(%Repository{} = repository, %Authors.User{} = user, attrs \\ %{}) do
    %Commit{}
    |> Commit.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:repository, repository)
    |> Repo.insert()
  end

  def save_commits(repository, commits) do
    result =
      commits
      |> Enum.with_index()
      |> Enum.reduce(Ecto.Multi.new(), fn {commit, index}, multi ->
        multi
        |> Multi.run(Integer.to_string(index), fn _repo, _changes ->
          create_commit(
            repository,
            Authors.find_or_create_author(commit["author"]),
            commit
          )
        end)
      end)
      |> Repo.transaction()

    result
  end

  def create_commit_with_assoc_release(
        %Repository{} = repository,
        %Authors.User{} = user,
        %Release{} = release,
        attrs \\ %{}
      ) do
    %Commit{}
    |> Commit.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:repository, repository)
    |> Ecto.Changeset.put_assoc(:release, release)
    |> Repo.insert()
  end

  def save_commits_included_in_the_release(repository, release, commits) do
    result =
      commits
      |> Enum.with_index()
      |> Enum.reduce(Ecto.Multi.new(), fn {commit, index}, multi ->
        multi
        |> Multi.run(Integer.to_string(index), fn _repo, _changes ->
          create_commit_with_assoc_release(
            repository,
            Authors.find_or_create_author(commit["author"]),
            release,
            commit
          )
        end)
      end)
      |> Repo.transaction()

    result
  end

  @doc """
  Updates a commit.

  ## Examples

      iex> update_commit(commit, %{field: new_value})
      {:ok, %Commit{}}

      iex> update_commit(commit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_commit(%Commit{} = commit, attrs) do
    commit
    |> Commit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a commit.

  ## Examples

      iex> delete_commit(commit)
      {:ok, %Commit{}}

      iex> delete_commit(commit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_commit(%Commit{} = commit) do
    Repo.delete(commit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking commit changes.

  ## Examples

      iex> change_commit(commit)
      %Ecto.Changeset{source: %Commit{}}

  """
  def change_commit(%Commit{} = commit) do
    Commit.changeset(commit, %{})
  end
end
