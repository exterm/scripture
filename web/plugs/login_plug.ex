defmodule Scripture.LoginPlug do
  use Scripture.Web, :plug
  alias Scripture.User

  def init(default), do: default

  def call(%Plug.Conn{params: params} = conn, _default) do
    user = case load_user_for_session(conn) do
             %User{} = logged_in_user ->
               logged_in_user
             nil ->
               try_login_and_get_user(params)
           end

    if user do
      conn
      |> put_session(:current_user, user.id)
      |> assign(:current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end

  defp try_login_and_get_user(%{"login_token" => token}) when is_binary(token) do
    user = Repo.get_by(User, login_token: token)
    max_token_age_seconds = 60 * 60 * 24

    if user && seconds_since_token_generated(user) <= max_token_age_seconds do
      user
    end
  end
  defp try_login_and_get_user(_params_without_token) do
    nil
  end

  defp seconds_since_token_generated(nil), do: nil
  defp seconds_since_token_generated(user) do
    DateTime.to_unix(DateTime.utc_now) - ecto_datetime_to_unix_timestamp(user.login_token_created_at)
  end

  defp ecto_datetime_to_unix_timestamp(datetime) do
    gregorian_seconds =
      datetime
      |> Ecto.DateTime.to_erl
      |> :calendar.datetime_to_gregorian_seconds
    gregorian_seconds - :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})
  end

  defp load_user_for_session(conn) do
    Repo.get(User, get_session(conn, :current_user) || 0)
  end
end
