json.array!(@records) do |record|
  json.extract! record, :id, :health_state, :user_id
  json.url record_url(record, format: :json)
end
