class Location < ActiveRecord::Base
  has_many :scores

  validates :country, presence: true
  validates :country_code, presence: true, uniqueness: true

  before_validation :set_country_and_code

  scope :with_score_count, ->{
    locations = arel_table
    scores = Score.arel_table
    count_scores = Arel::Nodes::Count.new([locations[:id]]).as('num_scores')
    joins(:scores).group(locations[:id]).
                   select(locations[Arel.star], count_scores.to_sql)
  }

  # Returns a saved Location with the given country name, case insensitive.
  def self.with_country country
    locations = arel_table
    lowercase_country = Arel::Nodes::NamedFunction.new('LOWER',
                                                       [locations[:country]])
    location = where(lowercase_country.eq(country.downcase.strip).to_sql).first
    return location if location
    create(country: country)
  end

  # Returns nil or a saved Location for the country of the given IP address.
  def self.for_ip_address ip_address
    country = local_ip_address_country_lookup(ip_address)
    country ||= remote_ip_address_country_lookup(ip_address)
    return if country.blank?
    with_country(country)
  end

  # Get a country name for the given IP address.
  def self.local_ip_address_country_lookup ip_address
    geoip = GeoIP.new(Rails.root.join('db', 'GeoIP.dat'))
    country_data = geoip.country(ip_address)
    return unless country_data
    country_data.country_name
  end

  # Get a country name for the given IP address.
  def self.remote_ip_address_country_lookup ip_address
    geocode_location = Geokit::Geocoders::MultiGeocoder.geocode(ip_address)
    if (country_code=geocode_location.country_code).present?
      country_data = Country[geocode_location.country_code]
      country_data ? country_data.name : nil
    else
      geocode_location.country
    end
  end

  def num_scores
    self['num_scores']
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
