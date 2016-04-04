defmodule MemoApi.PageController do
  use MemoApi.Web, :controller

  def index(conn, _params) do
    #render conn, "index.html"
    {:ok, version} = :application.get_key(:memo_api, :vsn)
    version = List.to_string(version)
    json conn, %{"version" => version}
  end
end

