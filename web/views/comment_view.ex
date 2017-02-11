defmodule Scripture.CommentView do
  use Scripture.Web, :view

  import Scripture.UserView, only: [full_name: 1]
  import Scripture.DateView, only: [formatted_datetime: 1]
end
