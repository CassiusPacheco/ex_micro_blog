defmodule ExMicroBlog.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias ExMicroBlog.Repo

  alias ExMicroBlog.Timeline.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Gets all posts and reposts made by the user by their id.

  ## Examples

      iex> get_user_posts_by_user_id(1)
      [%Post{}, ...]

  """
  def get_user_posts_by_user_id(id) do
    from(p in Post,
      where: p.user_id == ^id
    )
    |> Repo.all()
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
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
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
  Gets a single favorite.

  Raises `Ecto.NoResultsError` if the Favorite does not exist.

  ## Examples

      iex> get_favorite!(123)
      %Favorite{}

      iex> get_favorite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_favorite!(id), do: Repo.get!(Favorite, id)

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
  end

  @doc """
  Deletes a favorite.

  ## Examples

      iex> delete_favorite(favorite)
      {:ok, %Favorite{}}

      iex> delete_favorite(favorite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favorite(%Favorite{} = favorite) do
    Repo.delete(favorite)
  end

  alias ExMicroBlog.Timeline.Repost

  @doc """
  Returns the list of reposts.

  ## Examples

      iex> list_reposts()
      [%Repost{}, ...]

  """
  def list_reposts do
    Repo.all(Repost)
  end

  @doc """
  Gets a single repost.

  Raises `Ecto.NoResultsError` if the Repost does not exist.

  ## Examples

      iex> get_repost!(123)
      %Repost{}

      iex> get_repost!(456)
      ** (Ecto.NoResultsError)

  """
  def get_repost!(id), do: Repo.get!(Repost, id)

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
  end

  @doc """
  Deletes a repost.

  ## Examples

      iex> delete_repost(repost)
      {:ok, %Repost{}}

      iex> delete_repost(repost)
      {:error, %Ecto.Changeset{}}

  """
  def delete_repost(%Repost{} = repost) do
    Repo.delete(repost)
  end

  alias ExMicroBlog.Timeline.Hashtag

  @doc """
  Returns the list of hashtags.

  ## Examples

      iex> list_hashtags()
      [%Hashtag{}, ...]

  """
  def list_hashtags do
    Repo.all(Hashtag)
  end

  @doc """
  Gets a single hashtag.

  Raises `Ecto.NoResultsError` if the Hashtag does not exist.

  ## Examples

      iex> get_hashtag!(123)
      %Hashtag{}

      iex> get_hashtag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hashtag!(id), do: Repo.get!(Hashtag, id)

  @doc """
  Creates a hashtag.

  ## Examples

      iex> create_hashtag(%{field: value})
      {:ok, %Hashtag{}}

      iex> create_hashtag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hashtag(attrs \\ %{}) do
    %Hashtag{}
    |> Hashtag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a hashtag.

  ## Examples

      iex> delete_hashtag(hashtag)
      {:ok, %Hashtag{}}

      iex> delete_hashtag(hashtag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hashtag(%Hashtag{} = hashtag) do
    Repo.delete(hashtag)
  end

  alias ExMicroBlog.Timeline.Tagging

  @doc """
  Returns the list of taggings.

  ## Examples

      iex> list_taggings()
      [%Tagging{}, ...]

  """
  def list_taggings do
    Repo.all(Tagging)
  end

  @doc """
  Gets a single tagging.

  Raises `Ecto.NoResultsError` if the Tagging does not exist.

  ## Examples

      iex> get_tagging!(123)
      %Tagging{}

      iex> get_tagging!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tagging!(id), do: Repo.get!(Tagging, id)

  @doc """
  Creates a tagging.

  ## Examples

      iex> create_tagging(%{field: value})
      {:ok, %Tagging{}}

      iex> create_tagging(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tagging(attrs \\ %{}) do
    %Tagging{}
    |> Tagging.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a tagging.

  ## Examples

      iex> delete_tagging(tagging)
      {:ok, %Tagging{}}

      iex> delete_tagging(tagging)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tagging(%Tagging{} = tagging) do
    Repo.delete(tagging)
  end
end
