defmodule ExMicroBlog.Factory do
  use ExMachina.Ecto, repo: ExMicroBlog.Repo

  alias ExMicroBlog.Accounts.User
  alias ExMicroBlog.Timeline.{Post, Hashtag}

  def user_factory do
    %User{
      email: "cassius@test.com",
      handler: "@cassius",
      name: "Cassius Pacheco",
      password_hash: "hash"
    }
  end

  def user1_factory do
    %User{
      email: "julia@test.com",
      handler: "@julia",
      name: "Julia Jones",
      password_hash: "hash"
    }
  end

  def user2_factory do
    %User{
      email: "john@test.com",
      handler: "@john",
      name: "John Smith",
      password_hash: "hash"
    }
  end

  def user3_factory do
    %User{
      email: "maria@test.com",
      handler: "@maia",
      name: "Maria Silva",
      password_hash: "hash"
    }
  end

  def user4_factory do
    %User{
      email: "carla@test.com",
      handler: "@carla",
      name: "Carla Diniz",
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

  def hashtag_factory do
    %Hashtag{
      name: "#elixir"
    }
  end
end
