defimpl Phoenix.Param, for: Rumbl.Media.Video do
  def to_param(%{slug: slug, id: id}), do: "#{id}-#{slug}"
end
