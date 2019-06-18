defmodule RumblWeb.WatchController do
  use RumblWeb, :controller

  alias Rumbl.Media

  def show(conn, %{"id" => id}) do
    video = Media.get_video!(id)
    render(conn, "show.html", video: video)
  end
end
