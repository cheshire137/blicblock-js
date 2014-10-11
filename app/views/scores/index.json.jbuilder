json.scores @scores, partial: 'score', as: :score
json.page @scores.current_page
json.total_pages @scores.total_pages
json.total_records @scores.total_entries
