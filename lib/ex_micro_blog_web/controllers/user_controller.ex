defmodule ExMicroBlogWeb.UserController do
  use ExMicroBlogWeb, :controller

  import Phoenix.LiveView.Controller

  alias ExMicroBlog.Accounts
  alias ExMicroBlog.Accounts.User

  def index(conn, _params) do
    live_render(
      conn,
      ExMicroBlogWeb.UserLive.Index,
      session: %{
        "current_user_id" => get_session(conn, :user_id)
      }
    )
  end

  def username(conn, %{"username" => username}) do
    case Accounts.get_user_by_username(username) do
      %Accounts.User{} = user ->
        live_render(
          conn,
          ExMicroBlogWeb.UserLive.Show,
          session: %{
            "user_id" => user.id,
            "current_user_id" => get_session(conn, :user_id)
          }
        )

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
        |> redirect(to: Routes.user_path(conn, :username, user.username))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def follower(conn, %{"id" => user_id}) do
    live_render(
          conn,
          ExMicroBlogWeb.FollowerLive.Index,
          session: %{
            "user_id" => user_id,
            "current_user_id" => get_session(conn, :user_id)
          }
        )
  end

  def following(conn, %{"id" => user_id}) do
    live_render(
          conn,
          ExMicroBlogWeb.FollowingLive.Index,
          session: %{
            "user_id" => user_id,
            "current_user_id" => get_session(conn, :user_id)
          }
        )
  end

  # Authentication

  # defp authenticate(conn, _opts) do
  #   if conn.assigns.current_user do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "You must be logged in to access that page")
  #     |> redirect(to: Routes.timeline_path(conn, :index))
  #     |> halt()
  #   end
  # end
end
