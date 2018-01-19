# web/controllers/user_controller.ex
defmodule Ombib.UserController do
  use Ombib.Web, :controller
  
  alias Ombib.User

  plug :scrub_params, "user" when action in [:create]
  
  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end
  
  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end
  
  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Ombib.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
     end
   end
   
end