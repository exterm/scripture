defmodule Scripture.LoginTokenService do
  alias Scripture.{ Repo, User }
  alias Scripture.{ UserEmail, Mailer }

  def create_and_send_token(user, requested_path \\ "/") do
    new_token_params = User.new_login_token
    changeset = User.changeset(user, new_token_params)
    updated_user = Repo.update!(changeset)

    UserEmail.login_token(updated_user, requested_path) |> Mailer.deliver
  end

  def login_and_get_user(token) do
    user = Repo.get_by(User, login_token: token)
    max_token_age_seconds = 60 * 60 * 24

    if user && seconds_since_token_generated(user) <= max_token_age_seconds do
      user
    end
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
end
