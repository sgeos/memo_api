defmodule MemoApi.MemoView do
  use MemoApi.Web, :view

  def render("index.json", %{memos: memos}) do
    %{data: render_many(memos, MemoApi.MemoView, "memo.json")}
  end

  def render("show.json", %{memo: memo}) do
    %{data: render_one(memo, MemoApi.MemoView, "memo.json")}
  end

  def render("memo.json", %{memo: memo}) do
    %{id: memo.id,
      title: memo.title,
      body: memo.body,
      user_id: memo.user_id}
  end
end
