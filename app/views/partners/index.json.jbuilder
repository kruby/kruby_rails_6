json.array!(@partners) do |partner|
  json.extract! partner, :id, :name, :address, :postno, :city, :log, :category, :responsible, :info, :next_action, :lock_version, :user_id, :search_lock, :phone, :email, :homepage
  json.url partner_url(partner, format: :json)
end
