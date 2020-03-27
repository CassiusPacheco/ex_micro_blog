defmodule ExMicroBlogWeb.UserLive.Index do
  use Phoenix.LiveView

  alias ExMicroBlog.Accounts

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.UserView, "index.html", assigns)
  end

  def mount(_, %{"current_user_id" => current_user_id}, socket)
      when is_nil(current_user_id) do
    setup(socket, nil)
  end

  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    current_user = Accounts.get_user!(current_user_id)
    setup(socket, current_user)
  end

  defp setup(socket, current_user) do
    if connected?(socket) and not is_nil(current_user), do: Accounts.subscribe(current_user.id)
    users = Accounts.list_users()
    {:ok, assign(socket, current_user: current_user, users: users)}
  end

  # Handle Events

  def handle_info({Accounts, _event, _object}, socket) do
    # TODO: it's best to update it in a smarter way than re-fetching it all.
    users = Accounts.list_users()
    {:noreply, assign(socket, users: users)}
  end
end
