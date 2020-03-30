defmodule ExMicroBlogWeb.UserLive.New do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(ExMicroBlogWeb.UserView, "new.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
