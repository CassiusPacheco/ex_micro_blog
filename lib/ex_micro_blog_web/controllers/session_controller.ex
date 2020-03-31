defmodule ExMicroBlogWeb.SessionController do
  use ExMicroBlogWeb, :controller

  alias ExMicroBlog.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Accounts.authenticate_user_by_username(username, password) do
      {:ok, user} ->
        conn
        |> ExMicroBlogWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back #{user.name}!")
        |> redirect(to: Routes.user_path(conn, :index, username: username))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> ExMicroBlogWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
