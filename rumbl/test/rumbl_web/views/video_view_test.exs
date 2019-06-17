defmodule RumblWeb.VideoViewTest do
  use RumblWeb.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    videos = [
      %Rumbl.Media.Video{id: "1", title: "dogs"},
      %Rumbl.Media.Video{id: "2", title: "cats"},
    ]

    content = render_to_string(RumblWeb.VideoView, "index.html", conn: conn, videos: videos)

    assert content =~ "Listing Videos"

    for video <- videos, do: assert content =~ video.title
  end

  test "renders new.html", %{conn: conn} do
    owner = %Rumbl.Accounts.User{}
    changset = Rumbl.Media.change_video(owner, %Rumbl.Media.Video{})
    categories = [%Rumbl.Media.Category{id: 123, name: "cats"}]

    content = render_to_string(
      RumblWeb.VideoView,
      "new.html",
      conn: conn,
      changset: changset,
      categories: categories
    )

    assert content =~ "New Video"
  end
end
