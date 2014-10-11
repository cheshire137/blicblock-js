class Location < ActiveRecord::Base
  validates :country, presence: true, uniqueness: true

  before_create :capitalize_country

  private

  def capitalize_country
    return unless country
    self.country = country.split.map(&:capitalize).join(' ')
  end
end
