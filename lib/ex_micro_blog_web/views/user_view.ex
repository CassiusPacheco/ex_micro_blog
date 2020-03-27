defmodule ExMicroBlogWeb.UserView do
  use ExMicroBlogWeb, :view

  alias ExMicroBlog.Accounts.User

  def is_following?(%User{} = current_user, %User{} = user) do
    current_user.id == user.current_user_follower_id or
     current_user.id == user.current_user_following_id
  end
end
