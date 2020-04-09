defmodule GitActivityTracker.Activity.Release do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "releases" do
    field :released_at, :date
    field :tag_name, :string
    field :uuid, :integer
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(release, attrs) do
    release
    |> cast(attrs, [:uuid, :tag_name, :released_at])
    |> validate_required([:uuid, :tag_name, :released_at])
    |> unique_constraint(:uuid)
  end
end
