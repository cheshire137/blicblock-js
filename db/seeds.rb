puts 'Seed scores'
letters = ('A'..'Z').to_a
10.times do
  initials = letters.sample + letters.sample + letters.sample
  score = Score.create(initials: initials, value: (rand * 10).round * 1000,
                       created_at: rand(6).weeks.ago)
  if score.persisted?
    puts "\t#{score.value} by #{initials}"
  end
end
