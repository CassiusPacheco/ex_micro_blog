defmodule ExMicroBlogWeb.Router do
  use ExMicroBlogWeb, :router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExMicroBlogWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:handler", UserController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExMicroBlogWeb do
  #   pipe_through :api
  # end
end
