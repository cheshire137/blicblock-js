class Location < ActiveRecord::Base
  validates :country, presence: true, uniqueness: true

  before_create :capitalize_country

  def self.with_country country
    locations = arel_table
    lowercase_country = Arel::Nodes::NamedFunction.new('LOWER',
                                                       [locations[:country]])
    location = where(lowercase_country.eq(country.downcase.strip).to_sql).first
    return location if location
    create(country: country)
  end

  private

  def capitalize_country
    return unless country
    self.country = country.split.map(&:capitalize).join(' ').strip
  end
end
