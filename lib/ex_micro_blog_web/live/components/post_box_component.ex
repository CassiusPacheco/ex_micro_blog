defmodule ExMicroBlogWeb.PostBoxComponent do
  use Phoenix.LiveComponent

  alias ExMicroBlog.Timeline
  alias ExMicroBlog.Timeline.Post

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.PostView, "form.html", assigns)
  end

  def mount(%{"assigns" => %{"current_user" => user}} = socket) do
    attrs = %{"user_id" => user.id}
    {:ok, assign(socket, changeset: Timeline.change_post(%Post{}, attrs))}
  end

  def mount(socket) do
    {:ok, assign(socket, changeset: Timeline.change_post(%Post{}))}
  end

  # Handle events

  def handle_event("form_change", %{"post" => params}, socket) do
    params = Map.put(params, "user_id", socket.assigns.current_user.id)

    changeset =
      %Post{}
      |> Timeline.change_post(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"post" => params}, socket) do
    params = Map.put(params, "user_id", socket.assigns.current_user.id)

    case Timeline.create_post(params) do
      {:ok, _post} ->
        changeset = Timeline.change_post(%Post{})
        {:noreply, assign(socket, changeset: changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("Posting failed!")
        IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
