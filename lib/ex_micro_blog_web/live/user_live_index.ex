defmodule ExMicroBlogWeb.UserLive.Index do
  use Phoenix.LiveView

  alias ExMicroBlog.Accounts

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.UserView, "index.html", assigns)
  end

  def mount(_, %{"current_user_id" => current_user_id}, socket)
      when is_nil(current_user_id) do
    setup(nil, socket)
  end

  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    current_user = Accounts.get_user!(current_user_id)
    setup(current_user, socket)
  end

  # Helpers

  defp setup(current_user, socket) do
    if connected?(socket) and not is_nil(current_user) do
      Accounts.subscribe(current_user.id)
    end

    {:ok, assign_values(socket, current_user)}
  end

  defp assign_values(socket, current_user) do
    case current_user do
      nil ->
        assign(socket, current_user: nil, users: Accounts.list_users(nil))

      user ->
        assign(socket, current_user: user, users: Accounts.list_users(user.id))
    end
  end

  # Handle Events

  def handle_info({Accounts, _event, _object}, socket) do
    # TODO: it's best to update it in a smarter way than re-fetching it all.
    {:noreply, assign_values(socket, socket.assigns.current_user)}
  end
end
