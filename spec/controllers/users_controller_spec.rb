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

  describe "GET me" do
    %i(user owner admin).each do |current|
      describe "as #{current}" do
        it "returns the current user as json" do
          request.headers.merge! auth_header(send(current))
          get :me

          expect(response.status).to eq(200)
          expect(response.body).to   be_of_correct_schema(:user, send(current).id, send(current).admin)
        end
      end
    end

    it 'needs authentication' do
      get :me

      expect(response.status).to eq(401)
    end
  end

  describe "PUT update" do
    it "updates the requested attributes" do
      request.headers.merge! auth_header(owner)

      put :update, params: { id: owner.id, user: { name: "New Name", email: "new.email@changed.de" } }

      expect(response.status).to eq(204)
      expect(owner.reload.name).to eq("New Name")
      expect(owner.email).to eq("new.email@changed.de")
    end

    it "does not update when the passwords are not the same" do
      request.headers.merge! auth_header(owner)

      put :update, params: { id: owner.id, user: { password: 'bingo', password_confirmation: 'bongo' } }

      expect(response.status).to eq(400)
    end

    it 'needs authentication' do
      put :update, params: { id: owner.id, user: { name: "New Name" } }

      expect(response.status).to eq(401)
    end

    it 'does not update if wrong user reqested' do
      request.headers.merge! auth_header(user)
      put :update, params: { id: owner.id, user: { name: "New Name" } }

      expect(response.status).to eq(403)
    end

    it 'updates the user when requested by an admin' do
      request.headers.merge! auth_header(admin)
      put :update, params: { id: owner.id, user: { name: "New Name" } }

      expect(response.status).to eq(204)
      expect(owner.reload.name).to eq("New Name")
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

    it "as admin it returns no content and destroys the user" do
      request.headers.merge! auth_header(admin)

      expect{
        delete :destroy, params: { id: owner.id }
      }.to change{
        User.count
      }.by(-1)
      expect(response.status).to eq(204)
    end

    it 'needs authentication' do
      delete :destroy, params: { id: user.id }

      expect(response.status).to eq(401)
    end
  end
end
