defmodule GitActivityTracker.Activity.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "repositories" do
    field :name, :string
    field :uuid, :integer
    has_many :commits, GitActivityTracker.Activity.Commit

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:uuid, :name])
    |> validate_required([:uuid, :name])
    |> unique_constraint(:uuid)
  end
end
