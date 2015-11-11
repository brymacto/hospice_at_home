require 'rails_helper'


RSpec.describe ClientsController, type: :controller do
  describe 'POST #create' do
    fit 'renders the client that was created' do
      client = create(:client)

      post :create, :client => {:last_name => 'Doe', :first_name => 'John'}

      expect(response).to redirect_to("/clients/#{assigns(:client).id}")
    end
  end
end