describe Match do
  let!(:test_volunteer) { create(:volunteer) }
  let!(:test_client) { create(:client) }
  let!(:test_match) { create(:match, client_id: test_client.id, volunteer_id: test_volunteer.id) }

  describe "#name" do
    it "returns the name of the client followed by volunteer" do
      expect(test_match.name).to eq('John Doe and Jane Doe')
    end
  end
  describe "#client" do
    it "returns the name of the client" do
      expect(test_match.name).to eq('John Doe')
    end
  end
  describe "#volunteer" do
    it "returns the name of the volunteer" do
      expect(test_match.name).to eq('Jane Doe')
    end
  end

end