class Score < ActiveRecord::Base
  BAD_WORDS = %w(ASS CCK CNT COC COK COQ DCK DIK DIX FAG FCK FUC FUK FUQ KKK
                 KOK NIG POO TIT).freeze

  validates :value, presence: true, numericality: {greater_than: 0}
  validates :initials, presence: true, exclusion: {in: BAD_WORDS},
                       format: {with: /\A[a-zA-Z]{3}\z/}

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
