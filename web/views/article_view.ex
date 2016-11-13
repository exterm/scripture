defmodule Scripture.ArticleView do
  use Scripture.Web, :view

  import Scripture.DateView, only: [formatted_datetime: 1]

  def render_markdown(text) do
    Earmark.to_html(text)
  end
end
