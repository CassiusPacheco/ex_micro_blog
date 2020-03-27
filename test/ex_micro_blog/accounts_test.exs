defmodule ExMicroBlog.AccountsTest do
  use ExMicroBlog.DataCase, async: true

  import ExMicroBlog.Factory

  alias ExMicroBlog.Accounts

  describe "users" do
    alias ExMicroBlog.Accounts.User

    @valid_attrs %{
      username: "some username",
      name: "some name",
      password: "password",
      password_hash: Pbkdf2.hash_pwd_salt("password")
    }
    @update_attrs %{
      username: "some updated username",
      name: "some updated name",
      password: "updated password",
      password_hash: Pbkdf2.hash_pwd_salt("updated password")
    }
    @invalid_attrs %{username: nil, name: nil, password: nil, password_hash: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      Map.put(user, :password, nil)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_username!/1 returns nil when can't find user by given username" do
      _ = user_fixture()
      assert is_nil(Accounts.get_user_by_username("cassius"))
    end

    test "get_user_by_username!/1 returns the user with given username" do
      user = user_fixture()
      assert Accounts.get_user_by_username("some username") == user
    end

    test "list_following!/1 returns the following users with given user_id" do
      user = insert(:user)
      user1 = insert(:user1) |> Map.put(:password, nil)
      user2 = insert(:user2) |> Map.put(:password, nil)

      {:ok, _follower1} =
        Accounts.create_follower(%{"user_id" => user1.id, "follower_id" => user.id})

      {:ok, _follower2} =
        Accounts.create_follower(%{"user_id" => user2.id, "follower_id" => user.id})

      assert Accounts.list_following(user.id) == [
        user2 |> Map.put(:current_user_following_id, user.id),
        user1 |> Map.put(:current_user_following_id, user.id)]
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.username == "some username"
      assert user.name == "some name"
      assert Pbkdf2.verify_pass("password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.username == "some updated username"
      assert user.name == "some updated name"
      assert Pbkdf2.verify_pass("updated password", user.password_hash)
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
    alias ExMicroBlog.Repo

    test "list_followers/1 returns all followers by user_id" do
      user = insert(:user)
      user1 = insert(:user1) |> Map.put(:password, nil)
      user2 = insert(:user2) |> Map.put(:password, nil)

      {:ok, _follower1} =
        Accounts.create_follower(%{"user_id" => user.id, "follower_id" => user1.id})

      {:ok, _follower2} =
        Accounts.create_follower(%{"user_id" => user.id, "follower_id" => user2.id})

        {:ok, _follower3} =
          Accounts.create_follower(%{"user_id" => user1.id, "follower_id" => user.id})

      followers = Accounts.list_followers(user.id)

      assert followers == [
        user2,
        user1 |> Map.put(:current_user_follower_id, user.id)
      ],
      "Since user also follows user1, user's id should show up as the current user id"
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

      map = %{"user_id" => user.id, "follower_id" => user1.id}

      {:ok, follower} =
        Accounts.create_follower(map)

      assert :ok = Accounts.delete_follower(map)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Follower, follower.id) end
    end
  end
end
