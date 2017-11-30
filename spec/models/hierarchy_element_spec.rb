require 'rails_helper'

describe HierarchyElement do
  let(:campaign)  { FactoryBot.create(:campaign) }
  let(:element_a) { FactoryBot.create(:hierarchy_element, hierarchable: campaign,  visibility: :for_everyone) }
  let(:element_b) { FactoryBot.create(:hierarchy_element, hierarchable: element_a, visibility: :for_all_players) }
  let(:element_c) { FactoryBot.create(:hierarchy_element, hierarchable: element_b, visibility: :author_only) }

  subject { element_a }

  before(:each) do
    element_c
  end

  describe "destroy" do
    it "will remove all hierarchy_elements as well" do
      expect { subject.destroy }.to change { HierarchyElement.count }.by(-3)
    end

    it "will remove all content_texts as well" do
      subject.content_texts << FactoryBot.create(:content_text)

      expect { subject.destroy }.to change { ContentText.count }.by(-1)
    end

    it "will remove all hierarchy_elements_users as well" do
      user                         = FactoryBot.create(:user)
      campaign.players            << user
      subject.players_visible_for << user

      expect { subject.destroy }.to change { HierarchyElementsUser.count }.by(-1)
    end
  end

  describe "top_hierarchable" do
    it "will show the campaign in all elements" do
      expect(element_a.top_hierarchable).to eq(campaign)
      expect(element_b.top_hierarchable).to eq(campaign)
      expect(element_c.top_hierarchable).to eq(campaign)
    end
  end

  describe "visible_to" do
    describe "nil user" do
      it "is true to public elements" do
        expect(element_a.visible_to).to eq(true)
        expect(element_b.visible_to).to eq(false)
        expect(element_c.visible_to).to eq(false)
      end

      it "is false to public elements children to private elements" do
        element_c.update_attributes(visibility: :for_everyone)

        expect(element_c.visible_to).to eq(false)
      end
    end

    describe "player" do
      let(:player)    { FactoryBot.create(:user) }
      let(:element_d) { FactoryBot.create(:hierarchy_element, hierarchable: campaign, visibility: :for_some) }

      before(:each) do
        campaign.players << player
      end

      it "is true for some" do
        expect(element_a.visible_to(player)).to eq(true)
        expect(element_b.visible_to(player)).to eq(true)
        expect(element_c.visible_to(player)).to eq(false)
        expect(element_d.visible_to(player)).to eq(false)
      end

      it "is true for special players" do
        element_d.players_visible_for << player

        expect(element_d.visible_to(player)).to eq(true)
      end

      it "is false for elements children of author elements" do
        element_a.update_attributes(visibility: :author_only)

        expect(element_a.visible_to(player)).to eq(false)
        expect(element_b.visible_to(player)).to eq(false)
      end
    end

    it "is allways true to the owner of the campaign" do
      author = campaign.user

      expect(element_a.visible_to(author)).to eq(true)
      expect(element_b.visible_to(author)).to eq(true)
      expect(element_c.visible_to(author)).to eq(true)
    end
  end
end
