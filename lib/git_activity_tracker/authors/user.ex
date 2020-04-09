defmodule GitActivityTracker.Authors.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :username, :string
    field :uuid, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :uuid])
    |> validate_required([:username, :email, :uuid])
    |> unique_constraint(:email)
    |> unique_constraint(:uuid)
  end
end
