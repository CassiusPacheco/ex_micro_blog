defmodule ExMicroBlog.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ExMicroBlog.Repo

  alias ExMicroBlog.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @spec get_user!(any) :: any
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
  Gets a single user by handler.

  Returns nil if no result was found. Raises if more than one entry.

  ## Examples

      iex> get_user_by_handler(john)
      %User{}

      iex> get_user_by_handler(someoneelse)
      ** nil

  """
  def get_user_by_handler(handler), do: Repo.get_by(User, handler: handler)

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
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias ExMicroBlog.Accounts.Follower

  @doc """
  Returns the list of followers.

  ## Examples

      iex> list_followers()
      [%Follower{}, ...]

  """
  def list_followers do
    Repo.all(Follower)
  end

  @doc """
  Gets a single follower.

  Raises `Ecto.NoResultsError` if the Follower does not exist.

  ## Examples

      iex> get_follower!(123)
      %Follower{}

      iex> get_follower!(456)
      ** (Ecto.NoResultsError)

  """
  def get_follower!(id), do: Repo.get!(Follower, id)

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
  end

  @doc """
  Deletes a follower.

  ## Examples

      iex> delete_follower(follower)
      {:ok, %Follower{}}

      iex> delete_follower(follower)
      {:error, %Ecto.Changeset{}}

  """
  def delete_follower(%Follower{} = follower) do
    Repo.delete(follower)
  end

  def authenticate_user_by_email(email, password) do
    case Repo.get_by(Admin, email: email) do
      %User{} = user ->
        verify_password(user, password)

      nil ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  def authenticate_user_by_handler(handler, password) do
    case get_user_by_handler(handler) do
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
end
