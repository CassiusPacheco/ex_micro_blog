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

if (Application.get_env(:ex_micro_blog, :environment) != :test) do
  ExMicroBlog.Release.seed_db()
end
