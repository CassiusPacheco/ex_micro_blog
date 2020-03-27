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

    {:noreply, socket}
  end

  def handle_event("undo-favorite", _event, socket) do
    socket.assigns
    |> default_map()
    |> Timeline.delete_favorite()

    {:noreply, socket}
  end

  def handle_event("repost", _event, socket) do
    socket.assigns
    |> default_map()
    |> Timeline.create_repost()

    {:noreply, socket}
  end

  def handle_event("undo-repost", _event, socket) do
    socket.assigns
    |> default_map()
    |> Timeline.delete_repost()

    {:noreply, socket}
  end

  def handle_event("delete", _event, socket) do
    socket.assigns.post
    |> Timeline.delete_post()

    {:noreply, socket}
  end

  defp default_map(assigns) do
    %{
      "user_id" => assigns.current_user.id,
      "post_id" => assigns.post.id
    }
  end
end
