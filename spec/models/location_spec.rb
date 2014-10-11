require 'rails_helper'

RSpec.describe Location, type: :model do
  it 'requires a country' do
    expect(subject).to have(1).error_on(:country)
  end

  it 'requires a unique country code' do
    existing = create(:location)
    new_location = build(:location, country_code: existing.country_code)
    expect(new_location).to have(1).error_on(:country_code)
  end

  it 'adjusts capitalization of country on save' do
    new_location = build(:location, country: "\n\talGERia   ")
    new_location.save!
    expect(new_location.reload.country).to eq('Algeria')
  end

  it 'sets country code on save' do
    new_location = build(:location, country: "\n\talGERia   ")
    new_location.save!
    expect(new_location.reload.country_code).to eq('dz')
  end

  describe 'with_country' do
    let(:country) { "UnItEd STATES\r\n" }

    context 'when matching location does not already exist' do
      it 'returns a saved record' do
        expect(Location.with_country(country)).to be_persisted
      end

      it 'creates a new record' do
        expect { Location.with_country(country) }.
            to change(Location, :count).by(1)
      end

      it 'sets country code on new record' do
        Location.with_country(country)
        expect(Location.last.country_code).to eq('us')
      end

      it 'returns a record with adjusted capitalization' do
        expect(Location.with_country(country).country).
            to eq('United States')
      end
    end

    context 'when matching location already exists' do
      let!(:location) { create(:location, country: country) }

      it 'returns a saved record' do
        expect(Location.with_country(country)).to be_persisted
      end

      it 'does not create a new record' do
        expect { Location.with_country(country) }.
            to_not change(Location, :count)
      end

      it 'returns a record with adjusted capitalization' do
        expect(Location.with_country(country).country).
            to eq('United States')
      end
    end
  end
end
