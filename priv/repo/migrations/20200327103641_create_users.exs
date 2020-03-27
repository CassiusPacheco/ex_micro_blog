defmodule ExMicroBlog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :handler, :string, null: false
      add :password_hash, :string, null: false
      add :name, :string, null: false
      add :email, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:handler])
    create unique_index(:users, [:email])
  end
end
