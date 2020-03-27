defmodule ExMicroBlogWeb.PostComponent do
  use Phoenix.LiveComponent

  alias ExMicroBlog.Timeline

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.PostView, "post.html", assigns)
  end

  # Handle events

  def handle_event("favorite", _event, socket) do
    socket.assigns
    |> default_map()
    |> Timeline.create_favorite()
    |> IO.inspect()

    {:noreply, socket}
  end

  def handle_event("undo-favorite", _event, socket) do
    socket.assigns
    |> default_map()
    |> Timeline.delete_favorite()
    |> IO.inspect()

    {:noreply, socket}
  end

  def handle_event("repost", _event, socket) do
    if socket.assigns.post.user_id != socket.assigns.current_user.id do
      socket.assigns
      |> default_map()
      |> Timeline.create_repost()
      |> IO.inspect()
    end

    {:noreply, socket}
  end

  def handle_event("undo-repost", _event, socket) do
    socket.assigns
    |> default_map()
    |> Timeline.delete_repost()
    |> IO.inspect()

    {:noreply, socket}
  end

  defp default_map(assigns) do
    %{
      "user_id" => assigns.current_user.id,
      "post_id" => assigns.post.id
    }
  end
end
