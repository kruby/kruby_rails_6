json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :remember_token, :remember_token_expires_at, :active, :category, :blogname, :password_hash, :password_salt
  json.url user_url(user, format: :json)
end
