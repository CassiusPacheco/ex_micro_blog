defmodule ExMicroBlogWeb.UserController do
  use ExMicroBlogWeb, :controller

  import Phoenix.LiveView.Controller

  alias ExMicroBlog.Accounts

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

    # with user when not is_nil(user) <- Accounts.get_user_by_handler(handler),
    #      posts <- Timeline.get_user_posts_by_user_id(user.id) do
    #   live_render(conn, ExMicroBlogWeb.UserLive, session: %{"user_id" => user.id}
    #   # render(conn, "index.html", user: user, posts: posts)
    # else
    #   _ ->
    #     conn
    #     |> put_status(:not_found)
    #     |> put_view(ExMicroBlogWeb.ErrorView)
    #     |> render(:"404")
    # end
  end
end
