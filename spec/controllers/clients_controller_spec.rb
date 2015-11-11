require 'rails_helper'


RSpec.describe ClientsController, type: :controller do
  describe 'POST #create' do
    it 'renders the client that was created' do
      client = create(:client)

      post :create, {:last_name => 'Doe', :first_name => 'John'}

      expect(response).to render_template(:show)
    end
  end
end