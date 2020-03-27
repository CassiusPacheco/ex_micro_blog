defmodule ExMicroBlogWeb.PostView do
  use ExMicroBlogWeb, :view

  def char_count(%Ecto.Changeset{changes: %{text: text}}) do
    String.length(text)
  end

  def char_count(_changeset), do: 0

  def is_over_limit?(changeset), do: char_count(changeset) > 140
end
