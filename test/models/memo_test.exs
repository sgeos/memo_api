defmodule MemoApi.MemoTest do
  use MemoApi.ModelCase

  alias MemoApi.Memo

  @valid_attrs %{body: "some content", title: "some content", memo_post_id_fkey: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Memo.changeset(%Memo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Memo.changeset(%Memo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
