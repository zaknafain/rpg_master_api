require 'rails_helper'

RSpec.describe UsersController do
  
  let(:user) { FactoryBot.create(:user, email: "foo@bar.com", password: "secret pee", password_confirmation: "secret pee") }
  let(:authenticated_header) do
    token = Knock::AuthToken.new(payload: { sub: user.id, name: user.name }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end


  describe "GET index" do
    it 'returns all users as json' do
      request.headers.merge! authenticated_header
      get :index
  
      expect(response.status).to eq(200)
      expect(response.body).to include(user.name)
    end

    it 'needs authentication' do
      get :index

      expect(response.status).to eq(401)
    end 
  end
end
