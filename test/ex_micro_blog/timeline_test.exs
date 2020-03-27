defmodule ExMicroBlog.TimelineTest do
  use ExMicroBlog.DataCase, async: true

  import ExMicroBlog.Factory

  alias ExMicroBlog.Timeline

  describe "posts" do
    alias ExMicroBlog.Timeline.Post
    alias ExMicroBlog.Repo

    test "get_user_posts_by_user_id!/2 returns the post and reposts by given user id" do
      user = insert(:user) |> Map.put(:password, nil)
      post = insert(:post, user: user)
      post1 = insert(:post1, user: user)

      posts = Timeline.get_user_posts_by_user_id(user.id, nil)
      assert posts == [post1, post], "Posts are ordered as new ones first"
    end

    test "get_user_posts_by_user_id!/2 returns empty list for unexisting user id" do
      posts = Timeline.get_user_posts_by_user_id(123, nil)

      assert posts == []
    end

    test "create_post/1 with valid data creates a post" do
      user = insert(:user)
      post = %{"text" => "some text", "user_id" => user.id}

      assert {:ok, %Post{} = post} = Timeline.create_post(post)
      assert post.text == "some text"
      assert post.user_id == user.id
    end

    test "create_post/1 missing user returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_post(%{"text" => "hi"})
    end

    test "create_post/1 missing text returns error changeset" do
      user = insert(:user)
      post = %{"user_id" => user.id}

      assert {:error, %Ecto.Changeset{}} = Timeline.create_post(post)
    end

    test "delete_post/1 deletes the post" do
      post = insert(:post)

      assert {:ok, %Post{}} = Timeline.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Post, post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = %Post{text: "some text", user_id: 1}

      assert %Ecto.Changeset{} = Timeline.change_post(post)
    end
  end

  describe "favorites" do
    alias ExMicroBlog.Timeline
    alias ExMicroBlog.Timeline.Favorite
    alias ExMicroBlog.Repo

    def favorite_fixture do
      user = insert(:user)
      post = insert(:post, user: user)

      {:ok, favorite} = Timeline.create_favorite(%{"user_id" => user.id, "post_id" => post.id})
      favorite
    end

    test "list_favorites/0 returns all favorites" do
      favorite = favorite_fixture()

      fetched =
        Timeline.list_favorites()
        |> Enum.at(0)

      assert fetched.id == favorite.id
      assert fetched.user_id == favorite.user_id
      assert fetched.post_id == favorite.post_id
    end

    test "create_favorite/1 with valid data creates a favorite" do
      user = insert(:user)
      post = insert(:post, user: user)

      assert {:ok, %Favorite{} = favorite} =
               Timeline.create_favorite(%{"user_id" => user.id, "post_id" => post.id})
    end

    test "create_favorite/1 with unexisted user_id returns error changeset" do
      user = insert(:user)
      post = insert(:post, user: user)
      attrs = %{"post_id" => post.id, "user_id" => 0}

      assert {:error, %Ecto.Changeset{}} = Timeline.create_favorite(attrs)
    end

    test "create_favorite/1 with unexisted post_id returns error changeset" do
      user = insert(:user)
      attrs = %{"post_id" => 123, "user_id" => user.id}

      assert {:error, %Ecto.Changeset{}} = Timeline.create_favorite(attrs)
    end

    test "delete_favorite/1 deletes the favorite" do
      favorite = favorite_fixture()
      map = %{"user_id" => favorite.user_id, "post_id" => favorite.post_id}

      assert :ok = Timeline.delete_favorite(map)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Favorite, favorite.id) end
    end
  end

  describe "reposts" do
    alias ExMicroBlog.Timeline.Repost
    alias ExMicroBlog.Repo

    def repost_fixture do
      user = insert(:user)
      post = insert(:post, user: user)

      {:ok, repost} = Timeline.create_repost(%{"user_id" => user.id, "post_id" => post.id})
      repost
    end

    test "create_repost/1 with valid data creates a repost" do
      user = insert(:user)
      post = insert(:post, user: user)

      assert {:ok, %Repost{} = repost} =
               Timeline.create_repost(%{"user_id" => user.id, "post_id" => post.id})
    end

    test "create_repost/1 with unexistent user_id returns error changeset" do
      user = insert(:user)
      post = insert(:post, user: user)
      attrs = %{"post_id" => post.id, "user_id" => 0}

      assert {:error, %Ecto.Changeset{}} = Timeline.create_repost(attrs)
    end

    test "create_repost/1 with unexistent post_id returns error changeset" do
      user = insert(:user)
      attrs = %{"post_id" => 0, "user_id" => user.id}

      assert {:error, %Ecto.Changeset{}} = Timeline.create_repost(attrs)
    end

    test "delete_repost/1 deletes the repost" do
      repost = repost_fixture()
      map = %{"user_id" => repost.user_id, "post_id" => repost.post_id}

      assert :ok = Timeline.delete_repost(map)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Repost, repost.id) end
    end
  end
end
