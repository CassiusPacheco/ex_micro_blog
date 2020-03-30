defmodule ExMicroBlogWeb.UserLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.UserView, "index.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    posts = ExMicroBlog.Timeline.get_user_posts_by_user_id(user_id)
    user = ExMicroBlog.Accounts.get_user!(user_id)
    {:ok, assign(socket, user: user, posts: posts)}
  end
end
