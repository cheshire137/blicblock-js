require 'rails_helper'

RSpec.describe Score, type: :model do
  it 'requires initials' do
    expect(subject).to have(2).errors_on(:initials)
  end

  it 'requires value' do
    expect(subject).to have(2).errors_on(:value)
  end

  it 'disallows negative value' do
    subject.value = -1
    expect(subject).to have(1).error_on(:value)
  end

  it 'disallows zero value' do
    subject.value = 0
    expect(subject).to have(1).error_on(:value)
  end

  it 'disallows rude words for initials' do
    Score::BAD_WORDS.each do |initials|
      subject.initials = initials
      expect(subject).to have(1).error_on(:initials)
    end
  end

  it 'disallows initials with fewer than 3 characters' do
    subject.initials = 'a'
    expect(subject).to have(1).error_on(:initials)
    subject.initials = 'ab'
    expect(subject).to have(1).error_on(:initials)
  end

  it 'disallows initials with more than 3 characters' do
    subject.initials = 'abcd'
    expect(subject).to have(1).error_on(:initials)
  end

  it 'capitalizes initials on save' do
    subject = build(:score)
    subject.initials = 'abc'
    subject.save!
    expect(subject.reload.initials).to eq('ABC')
  end

  it 'allows multiple scores from different IPs within a minute' do
    score1 = create(:score, ip_address: '1.2.3.4')
    score2 = build(:score, ip_address: '8.9.4.5')
    expect(score2.save).to eq(true)
  end

  it 'allows multiple scores from the same IP at least a minute apart' do
    score1 = create(:score, ip_address: '1.2.3.4', created_at: 90.seconds.ago)
    score2 = build(:score, ip_address: score1.ip_address)
    expect(score2.save).to eq(true)
  end

  it 'disallows multiple scores from the same IP within a minute' do
    score1 = create(:score, ip_address: '1.2.3.4')
    score2 = build(:score, ip_address: score1.ip_address)
    expect(score2.save).to eq(false)
    expect(score2.errors[:base]).to_not be_empty
  end

  describe 'this_week' do
    it 'includes score made today' do
      score = create(:score)
      expect(Score.this_week).to include(score)
    end

    it 'excludes score made last week' do
      score = create(:score, created_at: 1.week.ago)
      expect(Score.this_week).to_not include(score)
    end

    it 'excludes score made next week' do
      score = create(:score, created_at: 1.week.from_now)
      expect(Score.this_week).to_not include(score)
    end
  end

  describe 'this_month' do
    it 'includes score made today' do
      score = create(:score)
      expect(Score.this_month).to include(score)
    end

    it 'excludes score made last month' do
      score = create(:score, created_at: 1.month.ago)
      expect(Score.this_month).to_not include(score)
    end

    it 'excludes score made next month' do
      score = create(:score, created_at: 1.month.from_now)
      expect(Score.this_month).to_not include(score)
    end
  end
end
