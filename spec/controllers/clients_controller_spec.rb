require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  describe 'POST #create' do
    it 'renders the client that was created' do
      client = create(:client)

      post :create, client: { last_name: 'Doe', first_name: 'John' }

      expect(response).to redirect_to("/clients/#{assigns(:client).id}")
    end
  end

  describe 'GET #index' do
    subject { get :index }

    fit 'renders the index view' do
      expect(subject).to render_template(:index)
    end
  end

  describe 'GET #new' do
    subject { get :new }

    fit 'renders the new view' do
      expect(subject).to render_template(:new)
    end
  end
end
