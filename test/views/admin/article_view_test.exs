defmodule Scripture.Admin.ArticleViewTest do
  use Scripture.ConnCase, async: true

  import Scripture.Admin.ArticleView

  test "truncate" do
    assert truncate("hallo", 200) == "hallo"
    assert truncate("Hallo Bernd", 5) == "Hallo..."
  end
end
