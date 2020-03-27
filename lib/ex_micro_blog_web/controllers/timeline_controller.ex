defmodule ExMicroBlogWeb.TimelineController do
  use ExMicroBlogWeb, :controller

  import Phoenix.LiveView.Controller

  alias ExMicroBlog.Accounts

  def index(conn, _params) do
    case conn.assigns.current_user do
      %Accounts.User{} = user ->
        live_render(
          conn,
          ExMicroBlogWeb.TimelineLive.Index,
          session: %{
            "user_id" => user.id
          }
        )

      _ ->
        conn
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end
end
