json.array!(@preferences) do |preference|
  json.extract! preference, :id, :name, :value, :user_id
  json.url preference_url(preference, format: :json)
end
