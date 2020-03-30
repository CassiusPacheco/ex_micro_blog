defmodule ExMicroBlogWeb.UserController do
  use ExMicroBlogWeb, :controller

  import Phoenix.LiveView.Controller

  alias ExMicroBlog.Accounts
  alias ExMicroBlog.Accounts.User

  plug :authenticate when action in [:show]

  def index(conn, %{"handler" => handler}) do
    case Accounts.get_user_by_handler(handler) do
      %Accounts.User{} = user ->
        live_render(conn, ExMicroBlogWeb.UserLive, session: %{"user_id" => user.id})

      _ ->
        conn
        |> put_status(:not_found)
        |> put_view(ExMicroBlogWeb.ErrorView)
        |> render(:"404")
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    live_render(conn, ExMicroBlogWeb.UserLive.New, session: %{"changeset" => changeset})
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> ExMicroBlogWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    # do whatever
    # render
    conn
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
