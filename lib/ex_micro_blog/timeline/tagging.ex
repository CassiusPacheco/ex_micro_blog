defmodule ExMicroBlog.Timeline.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMicroBlog.Timeline.Hashtag
  alias ExMicroBlog.Timeline.Post

  schema "taggings" do
    belongs_to :hashtag, Hashtag
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [:hashtag_id, :post_id])
    |> validate_required([:hashtag_id, :post_id])
    |> foreign_key_constraint(:hashtag_id)
    |> foreign_key_constraint(:post_id)
  end
end
