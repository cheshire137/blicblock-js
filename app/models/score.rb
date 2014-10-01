class Score < ActiveRecord::Base
  BAD_WORDS = %w(ASS CCK CNT COC COK COQ DCK DIK DIX FAG FCK FUC FUK FUQ KKK
                 KOK NIG POO TIT).freeze

  validates :value, presence: true, numericality: {greater_than: 0}
  validates :initials, presence: true, exclusion: {in: BAD_WORDS},
                       format: {with: /\A[a-zA-Z]{3}\z/}
  validate :not_playing_too_much

  scope :order_by_value, ->{
    order('value DESC, created_at DESC, id DESC')
  }

  scope :by_ip_address, ->(ip_address) { where(ip_address: ip_address) }

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
