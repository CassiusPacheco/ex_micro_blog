defmodule ExMicroBlog.TimelineTest do
  use ExMicroBlog.DataCase, async: true

  import ExMicroBlog.Factory

  alias ExMicroBlog.Timeline

  describe "posts" do
    alias ExMicroBlog.Accounts.User
    alias ExMicroBlog.Timeline.Post

    test "list_posts/0 returns all posts" do
      post = insert(:post)
      post1 = insert(:post1)
      posts = Timeline.list_posts()

      assert Enum.at(posts, 0).id == post.id
      assert Enum.at(posts, 0).text == post.text
      assert Enum.at(posts, 0).user_id == post.user_id

      assert Enum.at(posts, 1).id == post1.id
      assert Enum.at(posts, 1).text == post1.text
      assert Enum.at(posts, 1).user_id == post1.user_id
    end

    test "get_post!/1 returns the post with given id" do
      post = insert(:post)
      fetched = Timeline.get_post!(post.id)

      assert fetched.id == post.id
      assert fetched.text == post.text
      assert fetched.user_id == post.user_id
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
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = %Post{text: "some text", user_id: 1}

      assert %Ecto.Changeset{} = Timeline.change_post(post)
    end
  end

  describe "favorites" do
    alias ExMicroBlog.Timeline
    alias ExMicroBlog.Timeline.Favorite
    alias ExMicroBlog.Accounts.User

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

    test "get_favorite!/1 returns the favorite with given id" do
      favorite = favorite_fixture()

      assert Timeline.get_favorite!(favorite.id) == favorite
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

      assert {:ok, %Favorite{}} = Timeline.delete_favorite(favorite)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_favorite!(favorite.id) end
    end
  end

  describe "reposts" do
    alias ExMicroBlog.Timeline.Repost

    def repost_fixture do
      user = insert(:user)
      post = insert(:post, user: user)

      {:ok, repost} = Timeline.create_repost(%{"user_id" => user.id, "post_id" => post.id})
      repost
    end

    test "list_reposts/0 returns all reposts" do
      repost = repost_fixture()
      assert Timeline.list_reposts() == [repost]
    end

    test "get_repost!/1 returns the repost with given id" do
      repost = repost_fixture()
      assert Timeline.get_repost!(repost.id) == repost
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
      assert {:ok, %Repost{}} = Timeline.delete_repost(repost)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_repost!(repost.id) end
    end
  end

  describe "hashtags" do
    alias ExMicroBlog.Timeline.Hashtag

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def hashtag_fixture(attrs \\ %{}) do
      {:ok, hashtag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Timeline.create_hashtag()

      hashtag
    end

    test "list_hashtags/0 returns all hashtags" do
      hashtag = hashtag_fixture()
      assert Timeline.list_hashtags() == [hashtag]
    end

    test "get_hashtag!/1 returns the hashtag with given id" do
      hashtag = hashtag_fixture()
      assert Timeline.get_hashtag!(hashtag.id) == hashtag
    end

    test "create_hashtag/1 with valid data creates a hashtag" do
      assert {:ok, %Hashtag{} = hashtag} = Timeline.create_hashtag(@valid_attrs)
      assert hashtag.name == "some name"
    end

    test "create_hashtag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_hashtag(@invalid_attrs)
    end

    test "delete_hashtag/1 deletes the hashtag" do
      hashtag = hashtag_fixture()
      assert {:ok, %Hashtag{}} = Timeline.delete_hashtag(hashtag)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_hashtag!(hashtag.id) end
    end
  end

  describe "taggings" do
    alias ExMicroBlog.Timeline.Tagging

    def tagging_fixture do
      hashtag = insert(:hashtag)
      post = insert(:post)

      {:ok, tagging} =
        Timeline.create_tagging(%{"hashtag_id" => hashtag.id, "post_id" => post.id})

      tagging
    end

    test "list_taggings/0 returns all taggings" do
      tagging = tagging_fixture()
      assert Timeline.list_taggings() == [tagging]
    end

    test "get_tagging!/1 returns the tagging with given id" do
      tagging = tagging_fixture()
      assert Timeline.get_tagging!(tagging.id) == tagging
    end

    test "create_tagging/1 with valid data creates a tagging" do
      hashtag = insert(:hashtag)
      post = insert(:post)

      assert {:ok, %Tagging{} = tagging} =
               Timeline.create_tagging(%{"hashtag_id" => hashtag.id, "post_id" => post.id})
    end

    test "create_tagging/1 with unexistent post_id returns error changeset" do
      hashtag = insert(:hashtag)
      attrs = %{"post_id" => 0, "hashtag_id" => hashtag.id}

      assert {:error, %Ecto.Changeset{}} = Timeline.create_tagging(attrs)
    end

    test "create_tagging/1 with unexistent hashtag_id returns error changeset" do
      post = insert(:post)
      attrs = %{"post_id" => post.id, "hashtag_id" => 0}

      assert {:error, %Ecto.Changeset{}} = Timeline.create_tagging(attrs)
    end

    test "delete_tagging/1 deletes the tagging" do
      tagging = tagging_fixture()
      assert {:ok, %Tagging{}} = Timeline.delete_tagging(tagging)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_tagging!(tagging.id) end
    end
  end
end
