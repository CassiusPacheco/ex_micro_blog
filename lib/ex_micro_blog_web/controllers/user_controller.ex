defmodule ExMicroBlogWeb.UserController do
  use ExMicroBlogWeb, :controller

  alias ExMicroBlog.Accounts
  alias ExMicroBlog.Timeline

  def index(conn, %{"handler" => handler}) do
    with user when not is_nil(user) <- Accounts.get_user_by_handler(handler),
         posts <- Timeline.get_user_posts_by_user_id(user.id) do
      render(conn, "index.html", user: user, posts: posts)
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> put_view(ExMicroBlogWeb.ErrorView)
        |> render(:"404")
    end
  end
end
