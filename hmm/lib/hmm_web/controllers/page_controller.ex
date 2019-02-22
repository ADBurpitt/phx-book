defmodule HmmWeb.PageController do
  use HmmWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
