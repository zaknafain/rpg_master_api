# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampaignsController do
  let!(:public_campaign)  { FactoryBot.create(:campaign) }
  let!(:private_campaign) { FactoryBot.create(:campaign, is_public: false) }
  let!(:played_campaign)  { FactoryBot.create(:campaign, is_public: false, players: [owner]) }
  let(:owned_campaign)    { FactoryBot.create(:campaign, is_public: false) }
  let(:owner)             { owned_campaign.user }
  let(:user)              { FactoryBot.create(:user) }
  let(:admin)             { FactoryBot.create(:user, :admin) }

  describe 'GET index' do
    it 'returns status 200 and the correct schema' do
      get :index

      expect(response.status).to eq(200)
      expect(response.body).to of_correct_schema?(:campaign, nil, false)
    end

    it 'returns public, played and owned campaigns' do
      request.headers.merge! auth_header(owner)
      get :index

      expect(response.body).to include(public_campaign.name)
      expect(response.body).to include(played_campaign.name)
      expect(response.body).to include(owned_campaign.name)
      expect(response.body).not_to include(private_campaign.name)
    end

    it 'returns all campaigns for admins' do
      request.headers.merge! auth_header(admin)
      get :index

      expect(response.body).to include(public_campaign.name)
      expect(response.body).to include(played_campaign.name)
      expect(response.body).to include(owned_campaign.name)
      expect(response.body).to include(private_campaign.name)
    end

    it 'returns public campaigns even for not signed in users' do
      get :index

      expect(response.body).to include(public_campaign.name)
      expect(response.body).not_to include(played_campaign.name)
      expect(response.body).not_to include(owned_campaign.name)
      expect(response.body).not_to include(private_campaign.name)
    end
  end

  describe 'GET show' do
    it 'returns status 200 and the correct schema' do
      get :show, params: { id: public_campaign.id }

      expect(response.status).to eq(200)
      expect(response.body).to of_correct_schema?(:campaign, nil, false)
    end

    it 'returns public campaigns even for not logged in users' do
      get :show, params: { id: public_campaign.id }

      expect(response.body).to include(public_campaign.name)
    end

    it 'does not return private campaigns if the user is no player, admin or owner' do
      request.headers.merge! auth_header(owner)
      get :show, params: { id: private_campaign.id }

      expect(response.status).to eq(404)
    end

    it 'returns played campaigns for players' do
      request.headers.merge! auth_header(owner)
      get :show, params: { id: played_campaign.id }

      expect(response.body).to include(played_campaign.name)
    end

    it 'returns owned campaigns for owners' do
      request.headers.merge! auth_header(owner)
      get :show, params: { id: owned_campaign.id }

      expect(response.body).to include(owned_campaign.name)
    end

    it 'returns all campaigns for admins' do
      request.headers.merge! auth_header(admin)
      get :show, params: { id: private_campaign.id }

      expect(response.body).to include(private_campaign.name)
    end
  end
end
