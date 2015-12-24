class Score < ActiveRecord::Base
  BAD_WORDS = %w(ASS CCK CNT COC COK COQ DCK DIK DIX FAG FCK FUC FUK FUQ KKK
                 KOK NIG POO TIT).freeze

  belongs_to :location

  before_save :capitalize_initials
  before_create :set_location_from_ip_address

  validates :value, presence: true, numericality: {greater_than: 0}
  validates :initials, presence: true, exclusion: {in: BAD_WORDS},
                       format: {with: /\A[a-zA-Z]{3}\z/}
  validate :not_playing_too_much, on: :create

  scope :order_by_value, ->{
    scores = arel_table
    order(scores[:value].desc, scores[:created_at].desc, scores[:id].desc)
  }

  scope :order_by_newest, ->{ order(created_at: :desc) }
  scope :order_by_oldest, ->{ order(:created_at) }
  scope :by_ip_address, ->(ip_address) { where(ip_address: ip_address) }

  scope :last_seven_days, ->{
    week_end = Time.now.end_of_day
    week_start = week_end - 1.week
    where(created_at: week_start..week_end)
  }

  scope :last_thirty_days, ->{
    month_end = Time.now.end_of_day
    month_start = month_end - 30.days
    where(created_at: month_start..month_end)
  }

  scope :in_country, ->(country_codes) {
    country_codes = [country_codes] if country_codes.is_a?(String)
    clean_country_codes = country_codes.map {|str| str.strip.downcase }
    joins(:location).where(locations: {country_code: clean_country_codes})
  }

  # SELECT "scores".* FROM (
  #   SELECT "scores".*,
  #   DENSE_RANK() OVER (ORDER BY "scores"."value" DESC) AS rank
  #   FROM "scores"
  # ) scores
  scope :ranked, ->{
    scores = arel_table
    dense_rank = Arel::Nodes::SqlLiteral.new('DENSE_RANK()')
    window = Arel::Nodes::Window.new.order(scores[:value].desc)
    over = Arel::Nodes::Over.new(dense_rank, window).as('rank')
    rankings = scores.project(scores[Arel.star], over).as(Score.table_name)
    from(rankings).select(scores[Arel.star])
  }

  def rank
    self['rank'] || self.class.ranked.find(id)['rank']
  end

  def country
    return unless location
    location.country
  end

  def country_code
    return unless location
    location.country_code
  end

  def set_location_from_ip_address
    return if ip_address.blank?
    return if location
    self.location = Location.for_ip_address(ip_address)
  rescue => exception
    err_msg = "#{exception.message}\n#{exception.backtrace.join("\n")}"
    Rails.logger.error err_msg
  end

  private

  def capitalize_initials
    return unless initials
    self.initials = initials.upcase
  end

  def not_playing_too_much
    return if ip_address.blank?
    latest_score_by_ip = self.class.by_ip_address(ip_address).
                                    order(created_at: :desc).first
    return unless latest_score_by_ip
    cutoff_time = 1.minute.ago
    if latest_score_by_ip.created_at >= cutoff_time
      seconds_to_wait = (latest_score_by_ip.created_at - cutoff_time).round
      errors.add(:base, 'You can only submit once a minute. ' +
                        "Please wait another #{seconds_to_wait} " +
                        "#{'second'.pluralize(seconds_to_wait)}.")
    end
  end
end
