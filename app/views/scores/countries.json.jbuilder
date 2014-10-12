json.array! @locations do |location|
  json.name location.country
  json.code location.country_code
  json.total_scores @location_score_counts[location.id]
end
