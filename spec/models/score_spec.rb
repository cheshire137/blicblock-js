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
end
