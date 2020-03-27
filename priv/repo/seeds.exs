# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExMicroBlog.Repo.insert!(%ExMicroBlog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ExMicroBlog.Accounts
alias ExMicroBlog.Timeline

if (Application.get_env(:ex_micro_blog, :environment) != :test) do
  {:ok, cassius} =
    Accounts.create_user(%{
      "username" => "cassiuspacheco",
      "name" => "Cassius Pacheco",
      "password" => "password"
    })

  {:ok, julia} =
    Accounts.create_user(%{
      "username" => "julia",
      "name" => "Julia C.",
      "password" => "password"
    })

  {:ok, marcos} =
    Accounts.create_user(%{
      "username" => "marcos",
      "name" => "Marcão",
      "password" => "password"
    })

    {:ok, john} =
      Accounts.create_user(%{
        "username" => "john",
        "name" => "John Smith",
        "password" => "password"
      })

  {:ok, cassius_post1} =
    Timeline.create_post(%{
      "text" => "Hello World! #elixir",
      "user_id" => cassius.id
    })

  {:ok, _john_post1} =
    Timeline.create_post(%{
      "text" => "Oh yeah, fun project",
      "user_id" => john.id
    })

  {:ok, _cassius_post2} =
    Timeline.create_post(%{
      "text" => "I'm very excited about this new microblog app 😊",
      "user_id" => cassius.id
    })

  {:ok, julia_post1} =
    Timeline.create_post(%{
      "text" => "Can't wait for my next trip to Europe!",
      "user_id" => julia.id
    })

  {:ok, _julia_post2} =
    Timeline.create_post(%{
      "text" => "It's time to watch some movies! #stayhome",
      "user_id" => julia.id
    })

  {:ok, _cassius_fav1} =
    Timeline.create_favorite(%{
      "user_id" => cassius.id,
      "post_id" => julia_post1.id
    })

  {:ok, _cassius_fav2} =
    Timeline.create_favorite(%{
      "user_id" => cassius.id,
      "post_id" => cassius_post1.id
    })

  {:ok, _cassius_repost1} =
    Timeline.create_repost(%{
      "user_id" => cassius.id,
      "post_id" => julia_post1.id
    })

  {:ok, _marcos_post1} =
    Timeline.create_post(%{
      "text" => "Crossfit <3",
      "user_id" => marcos.id
    })

  {:ok, marcos_post2} =
    Timeline.create_post(%{
      "text" => "What's this new microblog site, eh?",
      "user_id" => marcos.id
    })

  {:ok, _cassius_fav3} =
    Timeline.create_favorite(%{
      "user_id" => cassius.id,
      "post_id" => marcos_post2.id
  })

  {:ok, _cassius_repost2} =
    Timeline.create_repost(%{
      "user_id" => cassius.id,
      "post_id" => marcos_post2.id
    })

  {:ok, _marcos_post3} =
    Timeline.create_post(%{
      "text" => "What's up with you all?",
      "user_id" => marcos.id
    })

  {:ok, _john_following1} =
    Accounts.create_follower(%{
      "follower_id" => john.id,
      "user_id" => cassius.id
    })

  {:ok, _cassius_following1} =
    Accounts.create_follower(%{
      "follower_id" => cassius.id,
      "user_id" => julia.id
    })

  {:ok, _cassius_following2} =
    Accounts.create_follower(%{
      "follower_id" => cassius.id,
      "user_id" => marcos.id
    })

  {:ok, _julia_following1} =
    Accounts.create_follower(%{
      "follower_id" => julia.id,
      "user_id" => cassius.id
    })

  {:ok, _marcos_following1} =
    Accounts.create_follower(%{
      "follower_id" => marcos.id,
      "user_id" => cassius.id
    })
end
