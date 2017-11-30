require 'rails_helper'

describe Campaign, type: :model do
  let(:campaign) { FactoryBot.create(:campaign, hierarchy_elements: [element], is_public: false) }
  let(:element)  { FactoryBot.create(:hierarchy_element) }
  let!(:player)  { FactoryBot.create(:user, campaigns_played: [campaign]) }

  subject { campaign }

  describe "all_campaigns_for user" do
    let!(:campaign_2) { FactoryBot.create(:campaign, user: player) }
    let!(:campaign_3) { FactoryBot.create(:campaign) }

    it "will show owned and played campaigns" do
      expect(Campaign.all_campaigns_for(player.id)).to     include(campaign)
      expect(Campaign.all_campaigns_for(player.id)).to     include(campaign_2)
      expect(Campaign.all_campaigns_for(player.id)).to_not include(campaign_3)
    end

    it "will show only owned campaigns if there are no played" do
      user = campaign.user

      expect(Campaign.all_campaigns_for(user.id)).to     include(campaign)
      expect(Campaign.all_campaigns_for(user.id)).to_not include(campaign_2)
      expect(Campaign.all_campaigns_for(user.id)).to_not include(campaign_3)
    end

    it "will show no campaigns if there are no played or owned" do
      user = FactoryBot.create(:user)

      expect(Campaign.all_campaigns_for(user.id)).to_not include(campaign)
      expect(Campaign.all_campaigns_for(user.id)).to_not include(campaign_2)
      expect(Campaign.all_campaigns_for(user.id)).to_not include(campaign_3)
    end
  end

  describe "destroy" do
    it "will remove all players as well" do
      expect { subject.destroy }.to change { CampaignsUser.count }.by(-1)
    end

    it "will remove all hierarchy_elements as well" do
      expect { subject.destroy }.to change { HierarchyElement.count }.by(-1)
    end
  end

  describe "visible_to" do
    describe "nil user" do
      it "is true to public campaigns" do
        subject.update_attributes(is_public: true)

        expect(subject.visible_to).to eq(true)
      end

      it "is false to private campaigns" do
        expect(subject.visible_to).to eq(false)
      end
    end

    describe "player" do
      it "is true for players of the campaign" do
        expect(subject.visible_to(player)).to eq(true)
      end

      it "is false for players of other campaigns" do
        user = FactoryBot.create(:user)

        expect(subject.visible_to(user)).to eq(false)
      end
    end

    it "is allways true to the owner of the campaign" do
      author = campaign.user

      expect(subject.visible_to(author)).to eq(true)
    end
  end
end
