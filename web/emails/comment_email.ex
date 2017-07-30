defmodule Scripture.CommentEmail do
  use Phoenix.Swoosh, view: Scripture.EmailView, layout: {Scripture.LayoutView, :email}

  import Scripture.UserView, only: [full_name: 1]

  def notify_admin_new_comment(admin, user, article, comment) do
    new()
    |> to({full_name(admin), admin.email})
    |> from({"Anna und Philip", "blog@annaundphilip.info"})
    |> subject("Neuer Kommentar von #{full_name(user)} im Blog")
    |> render_body("notify_admin_new_comment.html", %{
          user: user,
          article: article,
          comment: comment
    })
  end
end
