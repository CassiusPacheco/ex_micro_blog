defmodule ExMicroBlogWeb.PostView do
  use ExMicroBlogWeb, :view

  def human_readable_date(date) do
    now = NaiveDateTime.utc_now()

    if now.year == date.year do
      diff = NaiveDateTime.utc_now() |> NaiveDateTime.diff(date)
      mins = diff |> div(60)
      hours = mins |> div(60)

      case hours do
        0 ->
          case mins do
            0 ->
              "less than a min ago"

            1 ->
              "1 min ago"

            _ ->
              "#{mins} mins ago"
          end

        1 ->
          "1 hour ago"

        h when h in 2..24 ->
          "#{h} hours ago"

        h when h in 25..144 ->
          days = round(h / 24)

          if days == 1 do
            "1 day ago"
          else
            "#{days} days ago"
          end

        _ ->
          Calendar.Strftime.strftime(date, "%d %b")
      end
    else
      Calendar.Strftime.strftime(date, "%d %b %Y")
    end
  end
end
