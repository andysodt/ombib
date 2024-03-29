defmodule Ombib.SessionController do
  use Ombib.Web, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Ombib.User

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do

    case Ombib.Auth.login_by_email_and_pass(conn, email,
           password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now signed in!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end

  end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end

  defp logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end