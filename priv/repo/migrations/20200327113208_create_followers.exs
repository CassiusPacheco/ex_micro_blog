defmodule ExMicroBlog.Repo.Migrations.CreateFollowers do
  use Ecto.Migration

  def change do
    create table(:followers) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :follower_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:followers, [:user_id, :follower_id])
  end
end
