defmodule ExMicroBlog.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias ExMicroBlog.Repo

  alias ExMicroBlog.Timeline.{Post, Repost, Favorite}
  alias ExMicroBlog.Accounts.Follower
  alias ExMicroBlog.Accounts

  @topic inspect(__MODULE__)

  @doc """
  Gets all posts and reposts made by the user by their id.

  `current_user_id`, usually the logged in user, is used to
  define which user id should be used for marking whether
  the posts are reposted and/or favourited through the
  virtual properties `current_user_repost_id` and
  `current_user_favorite_id`.


  ## Examples

      iex> get_user_posts_by_user_id(1, 2)
      [%Post{}, ...]

  """
  def get_user_posts_by_user_id(id, current_user_id) do
    from(p in Post,
      left_join: r in Repost,
      on: p.id == r.post_id,
      where: p.user_id == ^id or r.user_id == ^id,
      group_by: [p.id, p.text, p.user_id, p.inserted_at, p.updated_at, r.user_id],
      select: %{p | current_user_repost_id: r.user_id},
      order_by: [desc: p.inserted_at, desc: p.id],
      preload: [:user]
    )
    |> Repo.all()
    |> put_favorite_id(current_user_id)
    |> put_repost_id(current_user_id)
  end

  @doc """
  Gets all posts that represent the user's timeline.

  It grabs posts and repost made by the user themselves
  as well as the posts and reposts made by the people
  they follow.

  The %Post struct will contain this user's id in the
  `current_user_repost_id` attribute when that post
  was reposted by the user from someone else, and
  `current_user_favorite_id` when the post was
  favorited.

  ## Examples

      iex> get_timeline_posts_by_user_id(1)
      [%Post{}, ...]

  """
  def get_timeline_posts_by_user_id(id) do
    users_posts = get_user_posts_by_user_id(id, id)
    users_posts_ids = users_posts |> Enum.map(& &1.id)

    from(p in Post,
      left_join: r in Repost,
      on: p.id == r.post_id,
      left_join: f in Follower,
      on: f.user_id == r.user_id or f.user_id == p.user_id,
      where: f.follower_id == ^id and p.id not in ^users_posts_ids,
      group_by: [p.id, p.text, p.user_id, p.inserted_at, p.updated_at],
      select: p,
      preload: [:user]
    )
    |> Repo.all()
    |> Enum.concat(users_posts)
    |> put_favorite_id(id)
    |> Enum.sort(&(&1.inserted_at > &2.inserted_at))
  end

  defp put_favorite_id(posts, user_id) when is_nil(user_id), do: posts

  defp put_favorite_id(posts, user_id) do
    # Fetches the favourites ids for a particular user
    # and sets the `current_user_favorite_id` of the
    # posts that were favourited by this user.

    favorites_ids =
      from(f in Favorite,
        where: f.user_id == ^user_id,
        select: f.post_id
      )
      |> Repo.all()

    posts
    |> Enum.map(fn post ->
      case Enum.member?(favorites_ids, post.id) do
        true ->
          %{post | current_user_favorite_id: user_id}

        false ->
          post
      end
    end)
  end

  defp put_repost_id(posts, user_id) when is_nil(user_id), do: posts

  defp put_repost_id(posts, user_id) do
    # Fetches the reposts ids for a particular user
    # and sets the `current_user_repost_id` of the
    # posts that were reposted by this user.

    reposts_ids =
      from(r in Repost,
        where: r.user_id == ^user_id,
        select: r.post_id
      )
      |> Repo.all()

    posts
    |> Enum.map(fn post ->
      case Enum.member?(reposts_ids, post.id) do
        true ->
          %{post | current_user_repost_id: user_id}

        false ->
          post
      end
    end)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:post, :created])
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
    |> notify_subscribers([:post, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias ExMicroBlog.Timeline.Favorite

  @doc """
  Returns the list of favorites.

  ## Examples

      iex> list_favorites()
      [%Favorite{}, ...]

  """
  def list_favorites do
    Repo.all(Favorite)
  end

  @doc """
  Creates a favorite.

  ## Examples

      iex> create_favorite(%{field: value})
      {:ok, %Favorite{}}

      iex> create_favorite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favorite(attrs \\ %{}) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:favorite, :created])
  end

  @doc """
  Deletes a favorite.

  ## Examples

      iex> delete_favorite(favorite)
      {:ok, %Favorite{}}

      iex> delete_favorite(favorite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favorite(%{"user_id" => user_id, "post_id" => post_id}) do
    from(f in Favorite,
      where:
        f.user_id == ^user_id and
          f.post_id == ^post_id
    )
    |> Repo.delete_all()
    |> notify_subscribers_user_id(user_id, [:favorite, :deleted])
  end

  alias ExMicroBlog.Timeline.Repost

  @doc """
  Creates a repost.

  ## Examples

      iex> create_repost(%{field: value})
      {:ok, %Repost{}}

      iex> create_repost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repost(attrs \\ %{}) do
    %Repost{}
    |> Repost.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:repost, :created])
  end

  @doc """
  Deletes a repost.

  ## Examples

      iex> delete_repost(repost)
      {:ok, %Repost{}}

      iex> delete_repost(repost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repost(%{"user_id" => user_id, "post_id" => post_id}) do
    from(f in Repost,
      where:
        f.user_id == ^user_id and
          f.post_id == ^post_id
    )
    |> Repo.delete_all()
    |> notify_subscribers_user_id(user_id, [:repost, :deleted])
  end

  # PubSub

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(ExMicroBlog.PubSub, @topic <> "#{user_id}")
  end

  def unsubscribe(user_id) do
    Phoenix.PubSub.unsubscribe(ExMicroBlog.PubSub, @topic <> "#{user_id}")
  end

  def subscribe_to_following_updates(user_id) do
    user_id
    |> Accounts.list_following(user_id)
    |> Enum.each(fn user ->
      subscribe(user.id)
    end)
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(
      ExMicroBlog.PubSub,
      @topic <> "#{result.user_id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}

  defp notify_subscribers_user_id({0, _} = result, _user_id, _event), do: result

  defp notify_subscribers_user_id(result, user_id, event) do
    Phoenix.PubSub.broadcast(
      ExMicroBlog.PubSub,
      @topic <> "#{user_id}",
      {__MODULE__, event, result}
    )
  end
end
