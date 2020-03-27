defmodule ExMicroBlog.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMicroBlog.Accounts.User
  alias ExMicroBlog.Timeline.{Favorite, Repost, Tagging}

  schema "posts" do
    field :text, :string
    belongs_to :user, User
    has_many :favorites, Favorite, foreign_key: :post_id
    has_many :reposts, Repost, foreign_key: :post_id
    has_many :taggings, Tagging, foreign_key: :post_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:text, :user_id])
    |> validate_required([:text, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
