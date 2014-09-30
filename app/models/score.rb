class Score < ActiveRecord::Base
  BAD_WORDS = %w(ass cck cnt coc cok coq dck dik dix fag fck fuc fuk fuq kkk
                 kok nig poo tit).freeze

  validates :value, presence: true
  validates :value, numericality: {greater_than_or_equal_to: 0}
  validates :initials, presence: true
  validates :initials, exclusion: {in: BAD_WORDS}
  validates :initials, format: {with: /\A[a-zA-Z]{3}\z/}

  scope :order_by_value, ->{
    order('value DESC, created_at DESC, id DESC')
  }

  before_save :capitalize_initials

  def rank
    # Add 1 because the index method returns a 0-based ranking.
    self.class.order_by_value.pluck(:id).index(id) + 1
  end

  private

  def capitalize_initials
    return unless initials
    self.initials = initials.upcase
  end
end
