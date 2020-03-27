defmodule ExMicroBlogWeb.PostView do
  use ExMicroBlogWeb, :view

  alias ExMicroBlog.Timeline.Post
  alias ExMicroBlog.Accounts.User

  def char_count(%Ecto.Changeset{changes: %{text: text}}) do
    String.length(text)
  end

  def char_count(_changeset), do: 0

  def is_over_limit?(changeset), do: char_count(changeset) > 140

  def is_deletable?(%Post{} = post, %User{} = current_user) do
    post.user_id == current_user.id
  end

  def is_deletable?(_post, _current_user), do: false
end
