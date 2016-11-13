defmodule Scripture.ArticleViewTest do
  use Scripture.ConnCase, async: true

  import Scripture.ArticleView

  test "render_markdown" do
    assert render_markdown("plain text") == "<p>plain text</p>\n"
    assert render_markdown("# headline") == "<h1>headline</h1>\n"
  end
end
