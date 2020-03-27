defmodule ExMicroBlogWeb.ViewHelper do
  alias ExMicroBlog.Timeline.Post
  alias ExMicroBlog.Accounts.User
  alias ExMicroBlog.Accounts

  # Followers and Followings
  def followers_count(%User{} = user) do
    Accounts.list_followers(user.id)
    |> Enum.count()
  end
  def following_count(%User{} = user) do
    Accounts.list_following(user.id)
    |> Enum.count()
  end

  # Logged In

  def is_logged_in(%User{} = user) when not is_nil(user), do: true
  def is_logged_in(%{"assigns" => %{current_user: user}}) when not is_nil(user), do: true

  def is_logged_in(_socket), do: false

  # Repost
  def is_repost?(%Post{} = post, %User{} = user) when not is_nil(post) and not is_nil(user) do
    user.id == post.current_user_repost_id
  end

  def is_repost?(_post, _user) do
    false
  end

  # Favorite
  def is_favorite?(%Post{} = post, %User{} = user) when not is_nil(post) and not is_nil(user) do
    user.id == post.current_user_favorite_id
  end

  def is_favorite?(_post, _user), do: false

  # Handler
  def handler(user), do: "@" <> user.username

  # Human Readable Date
  def human_readable_date(date) do
    now = NaiveDateTime.utc_now()

    if now.year == date.year do
      human_readable_same_year(date)
    else
      Calendar.Strftime.strftime(date, "%d %b %Y")
    end
  end

  defp human_readable_same_year(date) do
    diff = NaiveDateTime.utc_now() |> NaiveDateTime.diff(date)
    mins = diff |> div(60)
    hours = mins |> div(60)

    case hours do
      0 ->
        human_readable_min(mins)

      1 ->
        "1 hour ago"

      h when h in 2..23 ->
        "#{h} hours ago"

      h when h in 24..144 ->
        days = round(h / 24)

        if days == 1 do
          "1 day ago"
        else
          "#{days} days ago"
        end

      _ ->
        Calendar.Strftime.strftime(date, "%d %b")
    end
  end

  defp human_readable_min(mins) do
    case mins do
      0 ->
        "less than a min ago"

      1 ->
        "1 min ago"

      _ ->
        "#{mins} mins ago"
    end
  end
end
