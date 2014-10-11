class Location < ActiveRecord::Base
  validates :country, presence: true
  validates :country_code, presence: true, uniqueness: true

  before_validation :set_country_and_code

  def self.with_country country
    locations = arel_table
    lowercase_country = Arel::Nodes::NamedFunction.new('LOWER',
                                                       [locations[:country]])
    location = where(lowercase_country.eq(country.downcase.strip).to_sql).first
    return location if location
    create(country: country)
  end

  private

  def set_country_and_code
    if country.present?
      self.country = country.split.map(&:capitalize).join(' ').strip
      country_data = Country.find_country_by_name(country)
      if country_data && (code=country_data.alpha2)
        self.country_code = code.downcase
      end
    elsif country_code.present?
      country_data = Country[country_code]
      self.country = country_data.name if country_data
    end
  end
end
