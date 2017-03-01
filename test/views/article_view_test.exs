defmodule Scripture.ArticleViewTest do
  use Scripture.ConnCase, async: true

  import Scripture.ArticleView

  test "render_markdown" do
    assert render_markdown("plain text") == "<p>plain text</p>\n"
    assert render_markdown("# headline") == "<h1>headline</h1>\n"
  end

  test "fix dropbox urls when rendering markdown" do
    entered_string = "![alt text](https://www.dropbox.com/s/i7j8fju0jgfz7vi/IMG_20150813_084717.jpg?dl=0)"
    target_string = "<p><img src=\"https://dl.dropboxusercontent.com/s/i7j8fju0jgfz7vi/IMG_20150813_084717.jpg?dl=0\" " <>
                    "alt=\"alt text\"/></p>\n"

    assert render_markdown(entered_string) == target_string
  end

  test "don't change dropbox gallery urls when rendering markdown" do
    entered_string = "[a cool gallery](https://www.dropbox.com/sc/euu7r9v4y12my7a/AADFZagCxyBWhfxooO2ZhErWa)"
    target_string = "<p><a href=\"https://www.dropbox.com/sc/euu7r9v4y12my7a/AADFZagCxyBWhfxooO2ZhErWa\"" <>
                    ">a cool gallery</a></p>\n"

    assert render_markdown(entered_string) == target_string
  end
end
