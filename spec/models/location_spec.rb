require 'rails_helper'

RSpec.describe Location, type: :model do
  it 'requires a country' do
    expect(subject).to have(1).error_on(:country)
  end

  it 'requires a unique country' do
    existing = create(:location)
    new_location = build(:location, country: existing.country)
    expect(new_location).to have(1).error_on(:country)
  end

  it 'adjusts capitalization of country on save' do
    new_location = build(:location, country: 'THESE caps ARE wEiRD')
    new_location.save!
    expect(new_location.reload.country).to eq('These Caps Are Weird')
  end
end
