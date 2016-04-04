defmodule MemoApi.MemoControllerTest do
  use MemoApi.ConnCase

  alias MemoApi.User
  alias MemoApi.Memo
  @valid_attrs %{body: "some content", title: "some content", memos_user_id_fkey: 1}
  @invalid_attrs %{}

  setup %{conn: conn} do
    #%{email: "username", password_hash: "password_hash"}
    _user = Repo.insert! %User{}
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, memo_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    memo = Repo.insert! %Memo{}
    conn = get conn, memo_path(conn, :show, memo)
    assert json_response(conn, 200)["data"] == %{"id" => memo.id,
      "title" => memo.title,
      "body" => memo.body,
      "user_id" => memo.user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, memo_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, memo_path(conn, :create), memo: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Memo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, memo_path(conn, :create), memo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    memo = Repo.insert! %Memo{}
    conn = put conn, memo_path(conn, :update, memo), memo: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Memo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    memo = Repo.insert! %Memo{}
    conn = put conn, memo_path(conn, :update, memo), memo: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    memo = Repo.insert! %Memo{}
    conn = delete conn, memo_path(conn, :delete, memo)
    assert response(conn, 204)
    refute Repo.get(Memo, memo.id)
  end
end
