defmodule BussPhoenix.SignupController do
  use BussPhoenix.Web, :controller

  alias BussPhoenix.Repo
  alias BussPhoenix.User
  alias BussPhoenix.SignupView

  def new(conn, params) do
    changeset = User.login_changeset(%User{})
    render(conn, SignupView, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed up.")
        |> Guardian.Plug.sign_in(user, :token)
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, SignupView, "new.html", changeset: changeset)
    end
  end
end
