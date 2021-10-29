json.array!(@assets) do |asset|
  json.extract! asset, :id, :description, :user_id, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at
  json.url asset_url(asset, format: :json)
end
