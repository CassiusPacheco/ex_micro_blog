defmodule ExMicroBlogWeb.PostComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.PostView, "post.html", assigns)
  end
end
