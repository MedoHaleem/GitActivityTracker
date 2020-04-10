defmodule GitActivityTracker.Authors.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :username, :string
    field :uuid, :integer
    has_many :commits, GitActivityTracker.Activity.Commit
    has_many :releases, GitActivityTracker.Activity.Release
    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :uuid])
    |> validate_required([:username, :email, :uuid])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:uuid)
  end
end
