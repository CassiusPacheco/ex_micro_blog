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

{:ok, cassius_post1} =
  Timeline.create_post(%{
    "text" => "Hello World! #elixir",
    "user_id" => cassius.id
  })

{:ok, cassius_post2} =
  Timeline.create_post(%{
    "text" => "I'm very excited about this new microblog app 😊",
    "user_id" => cassius.id
  })

{:ok, julia_post1} =
  Timeline.create_post(%{
    "text" => "Can't wait for my next trip to Europe!",
    "user_id" => julia.id
  })

{:ok, cassius_fav1} = Timeline.create_favorite(%{
  "user_id" => cassius.id,
  "post_id" => julia_post1.id
  })

{:ok, cassius_repost1} = Timeline.create_repost(%{
  "user_id" => cassius.id,
  "post_id" => julia_post1.id
  })

{:ok, marcos_post1} = Timeline.create_post(%{
    "text" => "What's this new microblog site, eh?",
    "user_id" => marcos.id
  })

{:ok, cassius_repost2} = Timeline.create_repost(%{
  "user_id" => cassius.id,
  "post_id" => marcos_post1.id
  })

{:ok, cassius_following1} = Accounts.create_follower(%{
  "follower_id" => cassius.id,
  "user_id" => julia.id
  })

{:ok, cassius_following2} = Accounts.create_follower(%{
  "follower_id" => cassius.id,
  "user_id" => marcos.id
  })

{:ok, julia_following1} = Accounts.create_follower(%{
  "follower_id" => julia.id,
  "user_id" => cassius.id
  })

{:ok, marcos_following1} = Accounts.create_follower(%{
  "follower_id" => marcos.id,
  "user_id" => cassius.id
  })
