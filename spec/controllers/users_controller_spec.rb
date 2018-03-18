require 'rails_helper'

RSpec.describe UsersController do

  let(:user)  { FactoryBot.create(:user) }
  let(:owner) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, :admin) }

  describe "GET index" do
    before(:each) do
      user; owner; admin
    end

    %i(user owner admin).each do |current|
      describe "as #{current}" do
        it 'returns all users as json' do
          request.headers.merge! auth_header(send(current))
          get :index

          expect(response.status).to eq(200)
          expect(response.body).to   be_of_correct_schema(:user, send(current).id, send(current).admin)
        end
      end
    end

    it 'needs authentication' do
      get :index

      expect(response.status).to eq(401)
    end
  end

  describe "GET show" do
    %i(user owner admin).each do |current|
      describe "as #{current}" do
        it "returns the user as json" do
          request.headers.merge! auth_header(send(current))
          get :show, params: { id: owner.id }

          expect(response.status).to eq(200)
          expect(response.body).to   be_of_correct_schema(:user, send(current).id, send(current).admin)
        end
      end
    end

    it 'needs authentication' do
      get :show, params: { id: user.id }

      expect(response.status).to eq(401)
    end
  end
end
