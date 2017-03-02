defmodule Scripture.DateViewTest do
  use Scripture.ConnCase, async: true

  import Scripture.DateView

  test "formatted_datetime" do
    input_datetime = ~N[2017-02-12 00:01:33.039349]
    target_string = "12.02.2017, 01:01"

    assert formatted_datetime(input_datetime) == target_string
  end
end
