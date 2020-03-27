defmodule ExMicroBlog.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :hashtag_id, references(:hashtags, on_delete: :delete_all), null: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:taggings, [:hashtag_id, :post_id])
  end
end
