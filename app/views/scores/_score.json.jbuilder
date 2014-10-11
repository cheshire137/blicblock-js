json.extract! score, :id, :initials, :rank, :value, :created_at
if (location=score.location) && (country=location.country).present?
  json.country country
  if country_data=Country.find_country_by_name(country)
    json.country_code country_data.alpha2
  else
    json.country_code nil
  end
else
  json.country nil
  json.country_code nil
end
json.is_mine score.ip_address == @ip_address
json.url score_url(score, format: :json)
