defmodule ExMicroBlogWeb.FollowerLive.Index do
  use Phoenix.LiveView

  alias ExMicroBlog.Accounts

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.FollowerView, "index.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id, "current_user_id" => current_user_id}, socket) do
    if connected?(socket), do: Accounts.subscribe(user_id)

    if connected?(socket) and not is_nil(current_user_id) do
      Accounts.subscribe(current_user_id)
    end

    {:ok, assign_value(user_id, current_user_id, socket)}
  end

  defp assign_value(user_id, current_user_id, socket) do
    followers = Accounts.list_followers(user_id, current_user_id)
    user = Accounts.get_user!(user_id)

    case current_user_id do
      nil ->
        assign(socket, current_user: nil, user: user, followers: followers)

      _ ->
        current_user = Accounts.get_user!(current_user_id)
        assign(socket, current_user: current_user, user: user, followers: followers)
    end
  end

  # Handle Events

  def handle_info({Accounts, _event, _object}, socket) do
    # TODO: it's best to update it in a smarter way than re-fetching it all.
    assigns = socket.assigns
    {:noreply, assign_value(assigns.user.id, assigns.current_user.id, socket)}
  end
end
