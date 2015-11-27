describe "Volunteer" do
let!(:test_volunteer) { FactoryGirl.create(:volunteer) }
let!(:test_availability) { FactoryGirl.create(:volunteer_availability, day: 'monday', start_hour: 14, end_hour: 16, volunteer_id: test_volunteer.id) }
  describe "#available?" do
    it "returns true" do
      expect(test_volunteer.available?(Time.now)).to eq(true)
    end
  end


end