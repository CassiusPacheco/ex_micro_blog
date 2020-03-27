defmodule ExMicroBlog.Repo.Migrations.CreateReposts do
  use Ecto.Migration

  def change do
    create table(:reposts) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:reposts, [:user_id, :post_id])
  end
end
