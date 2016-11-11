defmodule Scripture.LoginPlug do
  use Scripture.Web, :plug
  import Scripture.LoginTokenService, only: [login_and_get_user: 1]
  alias Scripture.User

  def init(default), do: default

  def call(%Plug.Conn{params: params} = conn, _default) do
    user = case load_user_for_session(conn) do
             %User{} = logged_in_user ->
               logged_in_user
             nil ->
               conn.assigns[:current_user] || # tests assign this to spoof login :(
                 try_login_and_get_user(params)
           end

    if user do
      conn
      |> put_session(:current_user, user.id)
      |> assign(:current_user, user)
    else
      conn
      |> assign(:current_user, nil)
    end
  end

  defp try_login_and_get_user(%{"login_token" => token}) when is_binary(token), do: login_and_get_user(token)
  defp try_login_and_get_user(_params), do: nil

  defp load_user_for_session(conn) do
    user_id = get_session(conn, :current_user)
    if user_id do
      Repo.get(User, user_id)
    end
  end
end
