defmodule ExMicroBlog.AccountsTest do
  use ExMicroBlog.DataCase, async: true

  import ExMicroBlog.Factory

  alias ExMicroBlog.Accounts

  describe "users" do
    alias ExMicroBlog.Accounts.User

    @valid_attrs %{
      email: "some email",
      handler: "some handler",
      name: "some name",
      password_hash: "some password_hash"
    }
    @update_attrs %{
      email: "some updated email",
      handler: "some updated handler",
      name: "some updated name",
      password_hash: "some updated password_hash"
    }
    @invalid_attrs %{email: nil, handler: nil, name: nil, password_hash: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.handler == "some handler"
      assert user.name == "some name"
      assert user.password_hash == "some password_hash"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.handler == "some updated handler"
      assert user.name == "some updated name"
      assert user.password_hash == "some updated password_hash"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "followers" do
    alias ExMicroBlog.Accounts.Follower
    alias ExMicroBlog.Accounts

    test "list_followers/0 returns all followers" do
      user = insert(:user)
      user1 = insert(:user1)
      user2 = insert(:user2)

      {:ok, follower1} =
        Accounts.create_follower(%{"user_id" => user.id, "follower_id" => user1.id})

      {:ok, follower2} =
        Accounts.create_follower(%{"user_id" => user.id, "follower_id" => user2.id})

      assert Accounts.list_followers() == [follower1, follower2]
    end

    test "get_follower!/1 returns the follower with given id" do
      user = insert(:user)
      user1 = insert(:user1)

      {:ok, follower} =
        Accounts.create_follower(%{"user_id" => user.id, "follower_id" => user1.id})

      assert Accounts.get_follower!(follower.id) == follower
    end

    test "create_follower/1 with valid data creates a follower" do
      user = insert(:user)
      user1 = insert(:user2)

      assert {:ok, %Follower{} = follower} =
               Accounts.create_follower(%{"user_id" => user.id, "follower_id" => user1.id})
    end

    test "create_follower/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_follower(%{})
    end

    test "create_follower/1 fails when user tries to follow themselves" do
      user = insert(:user)

      assert {:error,
              %Ecto.Changeset{errors: ["Users can't follow themselves"], valid?: false} =
                changeset} =
               Accounts.create_follower(%{"user_id" => user.id, "follower_id" => user.id})
    end

    test "delete_follower/1 deletes the follower" do
      user = insert(:user)
      user1 = insert(:user1)

      {:ok, follower} =
        Accounts.create_follower(%{"user_id" => user.id, "follower_id" => user1.id})

      assert {:ok, %Follower{}} = Accounts.delete_follower(follower)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_follower!(follower.id) end
    end
  end
end
