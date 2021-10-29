json.array!(@contents) do |content|
  json.extract! content, :id, :name, :resource_id, :resource_type, :parent_id, :navlabel, :active, :admin, :position, :controller_name, :category
  json.url content_url(content, format: :json)
end
