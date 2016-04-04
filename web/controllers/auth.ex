defmodule MemoApi.Auth do
  import Phoenix.Controller
  #import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  #alias MemoApi.Router.Helpers

  #def init(opts) do
    #Keyword.fetch!(opts, :repo)
  #end

  #def call(conn, repo) do
    #user_id = get_session(conn, :user_id)

    #cond do
      #user = conn.assigns[:current_user] ->
        #put_current_user(conn, user)
      #user = user_id && repo.get(MemoApi.User, user_id) ->
        #put_current_user(conn, user)
      #true ->
        #assign(conn, :current_user, nil)
    #end
  #end

  def login_by_email_and_password(conn, email, given_password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(MemoApi.User, email: email)

    cond do
      user && checkpw(given_password, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def login(conn, verified_user) do
    conn
    |> Guardian.Plug.sign_in(verified_user)
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
  end

  def unauthenticated(conn, _params) do
    json conn, %{"status" => 401, "error" => "unauthorized"}
  end
end

