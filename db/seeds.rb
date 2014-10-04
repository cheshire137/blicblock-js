puts 'Seed scores'
letters = ('A'..'Z').to_a
50.times do
  initials = letters.sample + letters.sample + letters.sample
  score = Score.create(initials: initials, value: (rand * 10).round * 1000,
                       ip_address: Faker::Internet.ip_v4_address,
                       created_at: rand(6).weeks.ago)
  if score.persisted?
    puts "\t#{score.value} by #{initials} (#{score.ip_address})"
  end
end
