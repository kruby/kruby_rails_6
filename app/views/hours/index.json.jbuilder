json.array!(@hours) do |hour|
  json.extract! hour, :id, :description, :number, :date, :user_id, :relation_id
  json.url hour_url(hour, format: :json)
end
