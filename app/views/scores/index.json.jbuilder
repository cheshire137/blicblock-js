json.array!(@scores) do |score|
  json.extract! score, :id, :initials, :rank, :value, :created_at
  json.url score_url(score, format: :json)
end
