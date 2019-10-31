defmodule Rumbl.MediaTest do
  use Rumbl.DataCase

  alias Rumbl.Media
  alias Rumbl.Media.{Category, Video}

  describe "categories" do
    test "list_alphabetical_categories/0" do
      for name <- ~w(Drama Action Comedy), do: Media.create_category(name)

      alpha_names = for %Category{name: name} <- Media.list_alphabetical_categories(), do: name

      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    @valid_attrs %{description: "desc", title: "title", url: "http://local"}
    @invalid_attrs %{description: nil, title: nil, url: nil}

    test "list_videos/0 returns all videos" do
      owner = user_fixture()
      
      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Media.list_videos()

      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Media.list_videos()
    end

    test "get_video!/1 returns the video with given id" do
      owner = user_fixture()
      %Video{id: id} = video_fixture(owner)

      assert %Video{id: ^id} = Media.get_video!(id)
    end

    test "create_video/2 with valid data creates a video" do
      owner = user_fixture()

      assert {:ok, %Video{} = video} = Media.create_video(owner, @valid_attrs)
      assert video.description == "desc"
      assert video.title == "title"
      assert video.url == "http://local"
    end

    test "create_video/2 with invalid data returns error changeset" do
      owner = user_fixture()

      assert {:error, %Ecto.Changeset{}} = Media.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      owner = user_fixture()
      video = video_fixture(owner)

      assert {:ok, video} = Media.update_video(video, %{title: "updated title"})
      assert %Video{} = video
      assert video.title == "updated title"
    end

    test "updated_video/2 with invalid data returns error changeset" do
      owner = user_fixture()
      %Video{id: id} = video = video_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Media.update_video(video, @invalid_attrs)
      assert %Video{id: ^id} = Media.get_video!(id)
    end

    test "delete_video/1 deletes the video" do
      owner = user_fixture()
      video = video_fixture(owner)

      assert {:ok, %Video{}} = Media.delete_video(video)
      assert Media.list_videos() == []
    end

    test "change_video/2 returns a video changeset" do
      owner = user_fixture()
      video = video_fixture(owner)

      assert %Ecto.Changeset{} = Media.change_video(owner, video)
    end
  end

end