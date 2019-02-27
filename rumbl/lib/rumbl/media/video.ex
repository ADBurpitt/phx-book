defmodule Rumbl.Media.Video do
  use Ecto.Schema
  import Ecto.Changeset


  schema "videos" do
    field :url, :string
    field :description, :string
    field :title, :string

    belongs_to :user, Rumbl.Accounts.User
    belongs_to :category, Rumbl.Media.Category

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
  end
end