# frozen_string_literal: true

require 'rails_helper'

describe Campaign do
  let(:element)  { FactoryBot.create(:hierarchy_element) }
  let(:campaign) { element.hierarchable }
  let(:player)   { FactoryBot.create(:user) }

  before do
    player.campaigns_played << campaign
  end

  describe 'scopes' do
    describe 'visible_to user' do
      let!(:owned_campaign) { FactoryBot.create(:campaign, user: player, is_public: false) }
      let!(:public_campaign) { FactoryBot.create(:campaign) }
      let!(:private_campaign) { FactoryBot.create(:campaign, is_public: false) }

      it 'will show public, owned and played campaigns' do
        visible_campaigns = described_class.visible_to(player.id)

        expect(visible_campaigns).to     include(campaign)
        expect(visible_campaigns).to     include(owned_campaign)
        expect(visible_campaigns).to     include(public_campaign)
        expect(visible_campaigns).not_to include(private_campaign)
      end

      it 'will show public campaigns if the user is nil' do
        visible_campaigns = described_class.visible_to(nil)

        expect(visible_campaigns).to     include(campaign)
        expect(visible_campaigns).to     include(public_campaign)
        expect(visible_campaigns).not_to include(owned_campaign)
        expect(visible_campaigns).not_to include(private_campaign)
      end
    end
  end

  describe 'destroy' do
    it 'will remove all players as well' do
      expect { campaign.destroy }.to change(CampaignsUser, :count).by(-1)
    end

    it 'will remove all hierarchy_elements as well' do
      expect { campaign.destroy }.to change(HierarchyElement, :count).by(-1)
    end
  end

  describe 'visible_to' do
    before do
      campaign.update(is_public: false)
    end

    describe 'nil user' do
      it 'is true to public campaigns' do
        campaign.update(is_public: true)

        expect(campaign.visible_to).to eq(true)
      end

      it 'is false to private campaigns' do
        expect(campaign.visible_to).to eq(false)
      end
    end

    describe 'player' do
      it 'is true for players of the campaign' do
        expect(campaign.visible_to(player)).to eq(true)
      end

      it 'is false for players of other campaigns' do
        user = FactoryBot.create(:user)

        expect(campaign.visible_to(user)).to eq(false)
      end
    end

    it 'is allways true to the owner of the campaign' do
      author = campaign.user

      expect(campaign.visible_to(author)).to eq(true)
    end
  end
end
