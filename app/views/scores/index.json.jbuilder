json.array!(@scores) do |score|
  json.extract! score, :id, :initials, :rank, :value, :created_at
  json.is_mine score.ip_address == @ip_address
  json.url score_url(score, format: :json)
end
