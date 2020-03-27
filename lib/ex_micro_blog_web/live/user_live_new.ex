defmodule ExMicroBlogWeb.UserLive.New do
  use Phoenix.LiveView

  alias ExMicroBlogWeb.Router.Helpers, as: Routes
  alias ExMicroBlog.Accounts
  alias ExMicroBlog.Accounts.User

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.UserView, "new.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{changeset: Accounts.change_user(%User{})})}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %User{}
      |> Accounts.change_user(params)
      |> Accounts.validate_username()
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created")
         |> redirect(
           to:
             Routes.user_path(
               ExMicroBlogWeb.Endpoint,
               :username,
               user.username
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
