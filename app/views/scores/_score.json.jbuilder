json.extract! score, :id, :initials, :rank, :value, :created_at
if location=score.location
  json.country location.country
else
  json.country nil
end
json.is_mine score.ip_address == @ip_address
json.url score_url(score, format: :json)
