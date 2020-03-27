defmodule ExMicroBlogWeb.TimelineLive.Index do
  use Phoenix.LiveView

  alias ExMicroBlog.{Timeline, Accounts}

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.TimelineView, "index.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    if connected?(socket) do
      Timeline.subscribe_to_following_updates(user_id)
      Timeline.subscribe(user_id)
    end

    posts = Timeline.get_timeline_posts_by_user_id(user_id)
    user = Accounts.get_user!(user_id)
    {:ok, assign(socket, current_user: user, posts: posts)}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_user: nil, posts: nil)}
  end

  # Handle Events

  def handle_info({Timeline, _event, _object}, socket) do
    # TODO: it's best to update it in a smarter way than re-fetching it all.
    posts = Timeline.get_timeline_posts_by_user_id(socket.assigns.current_user.id)
    {:noreply, assign(socket, posts: posts)}
  end
end
