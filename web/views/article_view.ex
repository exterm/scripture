defmodule Scripture.ArticleView do
  use Scripture.Web, :view

  import Scripture.DateView, only: [formatted_datetime: 1]

  def render_markdown(text) do
    text
    |> fix_dropbox_image_urls
    |> Earmark.as_html!
  end

  defp fix_dropbox_image_urls(text) do
    String.replace(text, "//www.dropbox.com/s/", "//dl.dropboxusercontent.com/s/")
  end
end
