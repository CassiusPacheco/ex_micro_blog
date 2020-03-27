defmodule ExMicroBlogWeb.UserLive.Show do
  use Phoenix.LiveView

  alias ExMicroBlog.{Timeline, Accounts}

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.UserView, "show.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id, "current_user_id" => current_user_id}, socket) do
    if connected?(socket), do: Timeline.subscribe(user_id)

    if connected?(socket) and not is_nil(current_user_id) do
      Timeline.subscribe(current_user_id)
    end

    {:ok, assign_value(user_id, current_user_id, socket)}
  end

  defp assign_value(user_id, current_user_id, socket) do
    posts = Timeline.get_user_posts_by_user_id(user_id, current_user_id)
    user = Accounts.get_user!(user_id)

    case current_user_id do
      nil ->
        assign(socket, user: user, current_user: nil, posts: posts)

      _ ->
        current_user = Accounts.get_user!(current_user_id)
        assign(socket, user: user, current_user: current_user, posts: posts)
    end
  end

  # Handle Events

  def handle_info({Timeline, _event, _object}, socket) do
    # TODO: it's best to update it in a smarter way than re-fetching it all.
    assigns = socket.assigns
    {:noreply, assign_value(assigns.user.id, assigns.current_user.id, socket)}
  end
end
