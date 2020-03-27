defmodule ExMicroBlog.Repo do
  use Ecto.Repo,
    otp_app: :ex_micro_blog,
    adapter: Ecto.Adapters.Postgres
end
