defmodule GitActivityTracker.Activity.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tickets" do
    field :name, :string
    belongs_to :commit, GitActivityTracker.Activity.Commit

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> assoc_constraint(:commit)
  end
end
