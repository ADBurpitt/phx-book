defmodule Rumbl.Media.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Rumbl.Media.Permalink, autogenerate: true}
  schema "videos" do
    field :url, :string
    field :description, :string
    field :title, :string
    field :slug, :string

    belongs_to :user, Rumbl.Accounts.User
    belongs_to :category, Rumbl.Media.Category

    has_many :annotations, Rumbl.Media.Annotation

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description, :category_id])
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
    |> slugify_title()
  end

  defp slugify_title(changeset) do
    case fetch_change(changeset, :title) do
      {:ok, new_title} -> put_change(changeset, :slug, slugify(new_title))

      :error -> changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end