defmodule MemoApi.SessionController do
  use MemoApi.Web, :controller

  alias MemoApi.Auth

  plug :scrub_params, "user" when action in [:login]

  # useless for a JSON API, but useful for the browser
  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Auth.login_by_email_and_password(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        conn
        #|> put_flash(:info, "Logged in.")
        |> redirect(to: user_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(AppName.SessionView, "error.json", message: "Bad username or password.")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout
    #|> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end
end

