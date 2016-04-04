defmodule MemoApi.UserView do
  use MemoApi.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, MemoApi.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, MemoApi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email}
  end
end

