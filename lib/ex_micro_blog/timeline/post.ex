defmodule ExMicroBlog.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMicroBlog.Accounts.User
  alias ExMicroBlog.Timeline.{Favorite, Repost}

  schema "posts" do
    field :text, :string
    field :current_user_repost_id, :integer, virtual: true
    field :current_user_favorite_id, :integer, virtual: true
    belongs_to :user, User
    has_many :favorites, Favorite, foreign_key: :post_id
    has_many :reposts, Repost, foreign_key: :post_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:text, :user_id])
    |> validate_required([:text, :user_id])
    |> validate_length(:text, max: 140)
    |> foreign_key_constraint(:user_id)
  end
end
