defmodule ExMicroBlog.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ExMicroBlog.Repo
  alias ExMicroBlog.Accounts.User
  alias Ecto.Changeset

  @topic inspect(__MODULE__)

  @doc """
  Returns the list of users with `current_user_following_id`
  set if the `curent_user_id` passed in is valid.

  ## Examples

      iex> list_users(user_id)
      [%User{}, ...]

  """
  def list_users(curent_user_id \\ nil) do
    from(u in User,
      order_by: [desc: u.inserted_at, desc: u.id]
    )
    |> Repo.all()
    |> put_following_id(curent_user_id)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by username.

  Returns nil if no result was found. Raises if more than one entry.

  ## Examples

      iex> get_user_by_username(john)
      %User{}

      iex> get_user_by_username(someoneelse)
      ** nil

  """
  def get_user_by_username(username), do: Repo.get_by(User, username: username)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:user, :created])
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> notify_subscribers([:user, :updated])
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
    |> notify_subscribers([:user, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user, attrs \\ %{})
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def validate_username(%Ecto.Changeset{changes: %{username: username}} = changeset) do
    case get_user_by_username(username) do
      nil ->
        changeset

      _ ->
        changeset
        |> Changeset.add_error(:username, "username has already been taken", validation: :required)
    end
  end

  def validate_username(changeset), do: changeset

  alias ExMicroBlog.Accounts.Follower

  @doc """
  Returns whether a user follows the other
  user.

  ## Examples

      iex> is_following?(follower_id, user_id)
      true

  """
  def is_following?(follower_id, user_id) do
    from(f in Follower,
      where:
        f.follower_id == ^follower_id and
          f.user_id == ^user_id
    )
    |> Repo.exists?()
  end

  @doc """
  Returns the list of people this user follows.

  When `current_user_id` is passed in the users
  returned will contain the flag `current_user_following_id`
  whenever that user follows this one too.

  ## Examples

      iex> list_following(user_id, current_user_id)
      [%User{}, ...]

  """
  def list_following(user_id, current_user_id \\ nil) do
    from(u in User,
      join: f in Follower,
      on: f.user_id == u.id,
      where: f.follower_id == ^user_id,
      order_by: [desc: f.inserted_at, desc: u.id]
    )
    |> Repo.all()
    |> put_following_id(current_user_id)
  end

  @doc """
  Returns the list of people this user follows.

  When `current_user_id` is passed in the users
  returned will contain the flag `current_user_following_id`
  whenever that user follows this one too.

  ## Examples

      iex> list_following(user_id, current_user_id)
      [%User{}, ...]

  """
  def list_followers(user_id, current_user_id \\ nil) do
    from(u in User,
      left_join: f in Follower,
      on: f.follower_id == u.id,
      where: f.user_id == ^user_id,
      order_by: [desc: f.inserted_at, desc: u.id]
    )
    |> Repo.all()
    |> put_following_id(current_user_id)
  end

  defp put_following_id(users, user_id) when is_nil(user_id), do: users

  defp put_following_id(users, user_id) do
    # Fetches the following ids for a particular user
    # and sets the `current_user_following_id` of the
    # users that are being followed by this user.

    following_ids =
      from(f in Follower,
        where: f.follower_id == ^user_id,
        select: f.user_id
      )
      |> Repo.all()

    users
    |> Enum.map(fn user ->
      case Enum.member?(following_ids, user.id) do
        true ->
          %{user | current_user_following_id: user_id}

        false ->
          user
      end
    end)
  end

  @doc """
  Creates a follower.

  ## Examples

      iex> create_follower(%{field: value})
      {:ok, %Follower{}}

      iex> create_follower(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_follower(attrs \\ %{}) do
    %Follower{}
    |> Follower.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers(Map.get(attrs, "follower_id"), [:follower, :created])
  end

  @doc """
  Deletes a follower.

  ## Examples

      iex> delete_follower(map)
      {:ok, %Follower{}}

      iex> delete_follower(follower)
      {:error, %Ecto.Changeset{}}

  """
  def delete_follower(%{"follower_id" => follower_id, "user_id" => user_id}) do
    from(f in Follower,
      where:
        f.user_id == ^user_id and
          f.follower_id == ^follower_id
    )
    |> Repo.delete_all()
    |> notify_subscribers(follower_id, [:follower, :deleted])
  end

  # Authentication

  def authenticate_user_by_username(username, password) do
    username = username |> String.downcase() |> String.replace(" ", "")

    case get_user_by_username(username) do
      %User{} = user ->
        verify_password(user, password)

      nil ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  defp verify_password(user, password) do
    if Pbkdf2.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :unauthorized}
    end
  end

  # PubSub Subscription

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(ExMicroBlog.PubSub, @topic <> "#{user_id}")
  end

  def unsubscribe(user_id) do
    Phoenix.PubSub.unsubscribe(ExMicroBlog.PubSub, @topic <> "#{user_id}")
  end

  defp notify_subscribers({:ok, result}, event) do
    notify_subscribers({:ok, result}, result.id, event)
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}

  defp notify_subscribers({:ok, result}, user_id, event) do
    Phoenix.PubSub.broadcast(
      ExMicroBlog.PubSub,
      @topic <> "#{user_id}",
      {__MODULE__, event, result}
    )

    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _user_id, _event), do: {:error, reason}

  defp notify_subscribers({0, _} = result, _user_id, _event), do: result

  defp notify_subscribers(result, user_id, event) do
    Phoenix.PubSub.broadcast(
      ExMicroBlog.PubSub,
      @topic <> "#{user_id}",
      {__MODULE__, event, result}
    )
  end
end
