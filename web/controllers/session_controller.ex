defmodule BussPhoenix.SessionController do
  use BussPhoenix.Web, :controller

  alias BussPhoenix.Repo
  alias BussPhoenix.User
  alias BussPhoenix.SessionView

  def new(conn, params) do
    changeset = User.login_changeset(%User{})
    render(conn, SessionView, "new.html", changeset: changeset)
  end

  #def create(conn, params = %{}) do
  def create(conn, %{"user" => params} = %{}) do
    user = User
            |> User.by_email(params["email"] || "")
            |> Repo.one
    if user do
      changeset = User.login_changeset(user, params)
      if changeset.valid? do
        conn
        |> put_flash(:info, "Logged in.")
        |> Guardian.Plug.sign_in(user, :token)
        |> redirect(to: user_path(conn, :index))
      else
        render(conn, SessionView, "new.html", changeset: changeset)
      end
    else
      changeset = User.login_changeset(%User{}) |> Ecto.Changeset.add_error(:login, "not found")
      render(conn, SessionView, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end
end
