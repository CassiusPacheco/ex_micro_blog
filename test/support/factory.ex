defmodule ExMicroBlog.Factory do
  use ExMachina.Ecto, repo: ExMicroBlog.Repo

  alias ExMicroBlog.Accounts.User
  alias ExMicroBlog.Timeline.Post

  def user_factory do
    %User{
      username: "cassius",
      name: "Cassius Pacheco",
      password: "password",
      password_hash: "hash"
    }
  end

  def user1_factory do
    %User{
      username: "julia",
      name: "Julia C",
      password: "password",
      password_hash: "hash"
    }
  end

  def user2_factory do
    %User{
      username: "john",
      name: "John Smith",
      password: "password",
      password_hash: "hash"
    }
  end

  def user3_factory do
    %User{
      username: "maia",
      name: "Maria Silva",
      password: "password",
      password_hash: "hash"
    }
  end

  def user4_factory do
    %User{
      username: "carla",
      name: "Carla Diniz",
      password: "password",
      password_hash: "hash"
    }
  end

  def post_factory do
    %Post{
      text: "Hey there, this is my post!",
      user: build(:user)
    }
  end

  def post1_factory do
    %Post{
      text: "Hey there, this is another post! #elixir",
      user: build(:user1)
    }
  end

  def post2_factory do
    %Post{
      text: "My other new post",
      user: build(:user2)
    }
  end
end
