json.array!(@vouchers) do |voucher|
  json.extract! voucher, :id, :description, :number, :relation_id, :date, :user_id, :hourly_rate
  json.url voucher_url(voucher, format: :json)
end
