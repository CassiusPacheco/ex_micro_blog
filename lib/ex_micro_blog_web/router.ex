defmodule ExMicroBlogWeb.Router do
  use ExMicroBlogWeb, :router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ExMicroBlogWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExMicroBlogWeb do
    pipe_through :browser

    get "/", TimelineController, :index
    get "/users/:id/followers", UserController, :follower
    get "/users/:id/following", UserController, :following
    resources "/users", UserController, only: [:index, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/:username", UserController, :username
  end
end
