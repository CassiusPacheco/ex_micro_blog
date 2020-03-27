defmodule ExMicroBlog.Timeline.Hashtag do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMicroBlog.Timeline.Tagging

  schema "hashtags" do
    field :name, :string
    has_many :taggings, Tagging, foreign_key: :hashtag_id

    timestamps()
  end

  @doc false
  def changeset(hashtag, attrs) do
    hashtag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
