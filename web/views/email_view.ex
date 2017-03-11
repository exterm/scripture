defmodule Scripture.EmailView do
  use Scripture.Web, :view

  def login_link(token, requested_path) do
    String.trim_trailing(article_url(Scripture.Endpoint, :index), "/") <> requested_path <> "?login_token=" <> token
  end
end
