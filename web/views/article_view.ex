defmodule Scripture.ArticleView do
  use Scripture.Web, :view

  import Scripture.DateView, only: [formatted_datetime: 1]

  def render_markdown(text) do
    text
    |> fix_dropbox_image_urls
    |> Earmark.as_html!
    |> open_links_in_new_tab
  end

  defp fix_dropbox_image_urls(text) do
    String.replace(text, "//www.dropbox.com/s/", "//dl.dropboxusercontent.com/s/")
  end

  defp open_links_in_new_tab(text) do
    String.replace(text, ~r/(<a[^>]+)(>)/, "\\g{1} target='_blank'\\g{2}")
  end
end
