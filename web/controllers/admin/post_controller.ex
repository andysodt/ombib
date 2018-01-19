defmodule Ombib.Admin.PostController do
  use Ombib.Web, :controller
  alias Ombib.User

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Post |> Repo.get!(id)
    render(conn, "show.html", post: post)
  end

end