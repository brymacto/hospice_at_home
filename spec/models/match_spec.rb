describe Match do
  let!(:test_volunteer) { FactoryGirl.create(:volunteer) }
  let!(:test_client) { FactoryGirl.create(:client) }
  let!(:test_match) { FactoryGirl.create(:match, client_id: test_client.id, volunteer_id: test_volunteer.id, day: 'sunday', start_time: 10, end_time: 11) }

  describe '#client' do
    it 'returns the name of the client' do
      expect(test_match.client.name).to eq('John Doe')
    end
  end
  describe '#volunteer' do
    it 'returns the name of the volunteer' do
      expect(test_match.volunteer.name).to eq('Jane Doe')
    end
  end
end
