defmodule ExMicroBlogWeb.UserLive.Show do
  use Phoenix.LiveView

  alias ExMicroBlog.{Timeline, Accounts}

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.UserView, "show.html", assigns)
  end

  def mount(_, %{"user_id" => user_id, "current_user_id" => current_user_id}, socket)
      when is_nil(current_user_id) do
    setup(user_id, nil, socket)
  end

  def mount(_params, %{"user_id" => user_id, "current_user_id" => current_user_id}, socket) do
    current_user = Accounts.get_user!(current_user_id)
    setup(user_id, current_user, socket)
  end

  def mount(_, _session, socket) do

  end

  defp setup(user_id, current_user, socket) do
    if connected?(socket), do: Timeline.subscribe(user_id)
    user = Accounts.get_user!(user_id)
    posts = Timeline.get_user_posts_by_user_id(user_id)
    {:ok, assign(socket, user: user, current_user: current_user, posts: posts)}
  end

  # Handle Events

  def handle_info({Timeline, _event, _object}, socket) do
    # TODO: it's best to update it in a smarter way than re-fetching it all.
    posts = Timeline.get_user_posts_by_user_id(socket.assigns.user.id)
    {:noreply, assign(socket, posts: posts)}
  end
end
