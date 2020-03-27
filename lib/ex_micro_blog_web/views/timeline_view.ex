defmodule ExMicroBlogWeb.TimelineView do
  use ExMicroBlogWeb, :view

  alias ExMicroBlog.Timeline.Post

  def post_id(%Post{} = post) do
    case post.current_user_repost_id do
      nil ->
        "post-#{post.id}#{favorite_id(post)}"

      id ->
        "post-#{post.id}-#{id}#{favorite_id(post)}"
    end
  end

  defp favorite_id(%Post{} = post) do
    case post.current_user_favorite_id do
      nil -> ""
      id -> "-#{id}"
    end
  end
end
