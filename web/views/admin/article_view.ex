defmodule Scripture.Admin.ArticleView do
  use Scripture.Web, :view

  def truncate(text, length) do
    {beginning, ending} = String.split_at(text, length)
    ellipsis = if ending != "", do: "...", else: ""
    beginning <> ellipsis
  end
end
