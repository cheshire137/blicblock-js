json.array! @locations do |location|
  json.name location.country
  json.code location.country_code
end
