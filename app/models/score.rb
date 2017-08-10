class Score < ActiveRecord::Base
  BAD_WORDS = %w(ASS CCK CNT COC COK COQ DCK DIK DIX FAG FCK FUC FUK FUQ KKK
                 KOK NIG POO TIT).freeze

  belongs_to :location

  before_save :capitalize_initials

  validates :value, presence: true, numericality: {greater_than: 0}
  validates :initials, presence: true, exclusion: {in: BAD_WORDS},
                       format: {with: /\A[a-zA-Z]{3}\z/}

  scope :order_by_value, ->{
    scores = arel_table
    order(scores[:value].desc, scores[:created_at].desc, scores[:id].desc)
  }

  scope :order_by_newest, ->{ order(created_at: :desc) }
  scope :order_by_oldest, ->{ order(:created_at) }

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

  private

  def capitalize_initials
    return unless initials
    self.initials = initials.upcase
  end
end
