defmodule ExMicroBlog.Timeline.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMicroBlog.Accounts.User
  alias ExMicroBlog.Timeline.Post

  schema "favorites" do
    belongs_to :user, User
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:post_id)
  end
end
