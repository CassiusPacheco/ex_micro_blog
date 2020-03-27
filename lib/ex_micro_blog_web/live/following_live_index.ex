defmodule ExMicroBlogWeb.FollowingLive.Index do
  use Phoenix.LiveView

  alias ExMicroBlog.Accounts

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.FollowingView, "index.html", assigns)
  end

  def mount(_, %{"user_id" => user_id, "current_user_id" => current_user_id}, socket)
      when is_nil(current_user_id) do
    setup(user_id, nil, socket)
  end

  def mount(_params, %{"user_id" => user_id, "current_user_id" => current_user_id}, socket) do
    current_user = Accounts.get_user!(current_user_id)
    setup(user_id, current_user, socket)
  end

  defp setup(user_id, current_user, socket) do
    if connected?(socket) and not is_nil(current_user), do: Accounts.subscribe(current_user.id)
    user = Accounts.get_user!(user_id)
    following = Accounts.list_following(user_id)
    {:ok, assign(socket, current_user: current_user, user: user, following: following)}
  end

  # Handle Events

  def handle_info({Accounts, _event, _object}, socket) do
    # TODO: it's best to update it in a smarter way than re-fetching it all.
    following = Accounts.list_following(socket.assigns.user.id)
    {:noreply, assign(socket, following: following)}
  end
end
