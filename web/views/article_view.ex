defmodule Scripture.ArticleView do
  use Scripture.Web, :view

  import Scripture.DateView, only: [formatted_datetime: 1]

  @spec render_markdown(String.t) :: String.t
  def render_markdown(text) do
    text
    |> fix_dropbox_image_urls
    |> Earmark.as_html!
    |> open_links_in_new_tab
  end

  @spec fix_dropbox_image_urls(String.t) :: String.t
  defp fix_dropbox_image_urls(text) do
    String.replace(text, "//www.dropbox.com/s/", "//dl.dropboxusercontent.com/s/")
  end

  @spec open_links_in_new_tab(String.t) :: String.t
  defp open_links_in_new_tab(text) do
    String.replace(text, ~r/(<a[^>]+)(>)/, "\\g{1} target='_blank'\\g{2}")
  end
end
