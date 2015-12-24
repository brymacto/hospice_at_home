require 'rails_helper'

describe Match do
  let!(:test_volunteer) { create(:volunteer) }
  let!(:test_client) { create(:client) }
  let!(:test_match) do
    create(:match,
           client_id: test_client.id,
           volunteer_id: test_volunteer.id,
           day: 'sunday',
           start_time: 10,
           end_time: 11)
  end

  describe '#client' do
    it 'returns the name of the client' do
      expect(test_match.client_name).to eq('John Doe')
    end
  end

  describe '#volunteer' do
    it 'returns the name of the volunteer' do
      expect(test_match.volunteer_name).to eq('Jane Doe')
    end
  end

  it 'recognizes valid Match' do
    match = build_match

    expect(match).to be_valid
  end

  it 'validates that start_time precedes end_time' do
    match = build_match(start_time: 1, end_time: 1)

    expect(match).to_not be_valid
  end

  it 'validates that day is an actual day' do
    match = build_match(day: 'foo')

    expect(match).to_not be_valid
  end

  def build_match(start_time: 0, end_time: 24, day: 'monday', client_id: 1, volunteer_id: 1)
    Match.new(start_time: start_time, end_time: end_time, day: day, client_id: client_id, volunteer_id: volunteer_id)
  end
end
