defmodule ExMicroBlog.Repo.Migrations.CreateHashtags do
  use Ecto.Migration

  def change do
    create table(:hashtags) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:hashtags, [:name])
  end
end
