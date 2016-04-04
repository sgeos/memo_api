defmodule MemoApi.MemoController do
  use MemoApi.Web, :controller

  alias MemoApi.Memo

  plug :scrub_params, "memo" when action in [:create, :update]

  def index(conn, _params) do
    memos = Repo.all(Memo)
    render(conn, "index.json", memos: memos)
  end

  def create(conn, %{"memo" => memo_params}) do
    changeset = Memo.changeset(%Memo{}, memo_params)

    case Repo.insert(changeset) do
      {:ok, memo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", memo_path(conn, :show, memo))
        |> render("show.json", memo: memo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MemoApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    memo = Repo.get!(Memo, id)
    render(conn, "show.json", memo: memo)
  end

  def update(conn, %{"id" => id, "memo" => memo_params}) do
    memo = Repo.get!(Memo, id)
    changeset = Memo.changeset(memo, memo_params)

    case Repo.update(changeset) do
      {:ok, memo} ->
        render(conn, "show.json", memo: memo)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MemoApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    memo = Repo.get!(Memo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(memo)

    send_resp(conn, :no_content, "")
  end
end
