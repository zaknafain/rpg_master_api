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

  describe "DELETE destroy" do
    before(:each) do
      owner
    end

    it "as normal user it returns not allowed" do
      request.headers.merge! auth_header(user)
      delete :destroy, params: { id: owner.id }

      expect(response.status).to eq(401)
    end

    it "as owner it returns not allowed" do
      request.headers.merge! auth_header(owner)
      delete :destroy, params: { id: owner.id }

      expect(response.status).to eq(401)
    end

    it "as admin it returns ok and destroys the user" do
      request.headers.merge! auth_header(admin)

      expect{
        delete :destroy, params: { id: owner.id }
      }.to change{
        User.count
      }.by(-1)
      expect(response.status).to eq(200)
    end

    it 'needs authentication' do
      delete :destroy, params: { id: user.id }

      expect(response.status).to eq(401)
    end
  end
end
