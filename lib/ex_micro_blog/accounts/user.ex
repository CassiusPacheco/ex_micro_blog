defmodule ExMicroBlog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMicroBlog.Accounts.Follower
  alias ExMicroBlog.Timeline.Favorite
  alias ExMicroBlog.Timeline.Repost
  alias ExMicroBlog.Timeline.Post

  schema "users" do
    field :email, :string
    field :handler, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :following, Follower, foreign_key: :user_id
    has_many :followers, Follower, foreign_key: :follower_id
    has_many :favorites, Favorite, foreign_key: :user_id
    has_many :reposts, Repost, foreign_key: :user_id
    has_many :posts, Post, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:handler, :password_hash, :name, :email])
    |> validate_required([:handler, :password_hash, :name, :email])
    |> unique_constraint(:handler)
    |> unique_constraint(:email)
  end
end
