defmodule Scripture.EmailView do
  use Scripture.Web, :view

  import Scripture.UserView, only: [full_name: 1]
  import Scripture.DateView, only: [formatted_datetime: 1]

  def login_link(token, requested_path) do
    String.trim_trailing(article_url(Scripture.Endpoint, :index), "/") <> requested_path <> "?login_token=" <> token
  end
end
