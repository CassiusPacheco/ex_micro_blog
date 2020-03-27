defmodule ExMicroBlog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMicroBlog.Accounts.Follower
  alias ExMicroBlog.Timeline.Favorite
  alias ExMicroBlog.Timeline.Repost
  alias ExMicroBlog.Timeline.Post

  schema "users" do
    field :username, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :current_user_following_id, :integer, virtual: true
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
    |> cast(attrs, [:username, :password, :name])
    |> validate_required([:username, :password, :name])
    |> format_username()
    |> validate_format(:username, ~r/^[a-zA-Z0-9]+$/)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp format_username(%Ecto.Changeset{valid?: true, changes: %{username: username}} = changeset) do
    change(changeset, username: username |> String.downcase() |> String.replace(" ", ""))
  end

  defp format_username(changeset), do: changeset

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
