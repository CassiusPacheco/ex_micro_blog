defmodule ExMicroBlog.Accounts.Follower do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMicroBlog.Accounts.User

  schema "followers" do
    belongs_to :user, User
    belongs_to :follower, User

    timestamps()
  end

  @doc false
  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :follower_id])
    |> validate_required([:user_id, :follower_id])
    |> validate_ids()
  end

  defp validate_ids(
         %Ecto.Changeset{valid?: true, changes: %{user_id: user_id, follower_id: follower_id}} =
           changeset
       ) do
    if user_id == follower_id do
      %Ecto.Changeset{valid?: false, errors: ["Users can't follow themselves"]}
    else
      changeset
    end
  end

  defp validate_ids(changeset), do: changeset
end
