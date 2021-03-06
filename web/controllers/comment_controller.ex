defmodule Scripture.CommentController do
  use Scripture.Web, :controller

  alias Scripture.{Comment, User, Article, CommentEmail, Mailer}

  def create(conn, %{"comment" => comment_params}) do
    user_id = conn.assigns[:current_user].id
    comment_params_with_user = Map.put(comment_params, "user_id", user_id)
    changeset = Comment.changeset(%Comment{}, comment_params_with_user)

    article_id = comment_params["article_id"]

    case Repo.insert(changeset) do
      {:ok, comment} ->
        send_admin_notifications(user_id, article_id, comment)
        conn
        |> put_flash(:info, "Kommentar gespeichert.")
        |> redirect(to: article_path(conn, :show, article_id))
      {:error, _changeset} ->
        Rollbax.report(:throw, :comment_validation_error, System.stacktrace(),
                       %{user: conn.assigns[:current_user].email,
                         comment_params: comment_params})
        conn
        |> put_flash(:error, "Kommentar konnte nicht gespeichert werden.")
        |> redirect(to: article_path(conn, :show, article_id))
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!((from c in Comment, preload: :user), id)

    if conn.assigns[:current_user] == comment.user do
      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(comment)

      conn
      |> put_flash(:info, "Kommentar gelöscht.")
      |> redirect(to: article_path(conn, :show, comment.article_id))
    else
      conn
      |> redirect(to: article_path(conn, :show, comment.article_id))
    end
  end

  defp send_admin_notifications(author_id, article_id, comment) do
    author = Repo.get(User, author_id)
    article = Repo.get(Article, article_id)
    admins = Repo.all(User.admins)
    Enum.each(admins, fn(admin) ->
      unless admin == author do
        CommentEmail.notify_admin_new_comment(admin, author, article, comment) |> Mailer.deliver
      end
    end)
  end
end
