defmodule ExMicroBlogWeb.UserComponent do
  use Phoenix.LiveComponent

  alias ExMicroBlog.Accounts

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.UserView, "user.html", assigns)
  end

  # Handle events

  def handle_event("follow", _event, socket) do
    socket.assigns
    |> default_map()
    |> Accounts.create_follower()
    |> IO.inspect()

    {:noreply, socket}
  end

  def handle_event("unfollow", _event, socket) do
    socket.assigns
    |> default_map()
    |> Accounts.delete_follower()
    |> IO.inspect()

    {:noreply, socket}
  end

  defp default_map(assigns) do
    %{
      "user_id" => assigns.user.id,
      "follower_id" => assigns.current_user.id
    }
  end
end
