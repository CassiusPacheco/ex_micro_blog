defmodule ExMicroBlogWeb.UserView do
  use ExMicroBlogWeb, :view

  alias ExMicroBlog.Accounts.User

  def is_following?(%User{} = current_user, %User{} = user) do
    current_user.id == user.current_user_following_id
  end

  def should_show_follow_button?(%User{} = current_user, %User{} = user) do
    current_user.id != user.id
  end

  def should_show_follow_button?(_current_user, _user), do: false
end
