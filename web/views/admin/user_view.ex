defmodule Scripture.Admin.UserView do
  use Scripture.Web, :view

  def full_name(user) do
    user.first_name <> " " <> user.last_name
  end
end
