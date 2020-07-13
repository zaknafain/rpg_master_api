# frozen_string_literal: true

require 'rails_helper'

describe ContentText do
  let(:campaign)     { FactoryBot.create(:campaign) }
  let(:player)       { FactoryBot.create(:user) }
  let(:element) do
    FactoryBot.create(
      :hierarchy_element,
      hierarchable: campaign,
      visibility: :for_everyone
    )
  end
  let(:content_text) do
    FactoryBot.create(
      :content_text,
      hierarchy_element: element,
      visibility: :for_everyone
    )
  end

  describe 'scopes' do
    describe 'ordered' do
      it 'sorts by ordering asc and id asc' do
        content_text_n1 = FactoryBot.create(
          :content_text, hierarchy_element: element
        )
        content_text_n2 = FactoryBot.create(
          :content_text, hierarchy_element: element
        )
        content_text_o2 = FactoryBot.create(
          :content_text, hierarchy_element: element, ordering: 2
        )
        content_text_o1 = FactoryBot.create(
          :content_text, hierarchy_element: element, ordering: 1
        )
        ordered_ids = element.content_texts.ordered.map(&:id)

        expect(
          ordered_ids.index(content_text_o1.id) <
          ordered_ids.index(content_text_o2.id)
        ).to be_truthy
        expect(
          ordered_ids.index(content_text_o2.id) <
          ordered_ids.index(content_text_n1.id)
        ).to be_truthy
        expect(
          ordered_ids.index(content_text_n1.id) <
          ordered_ids.index(content_text_n2.id)
        ).to be_truthy
      end
    end
  end

  describe 'destroy' do
    it 'will remove all content_texts_users as well' do
      campaign.players                 << player
      content_text.players_visible_for << player

      expect { content_text.destroy }.to change(ContentTextsUser, :count).by(-1)
    end
  end

  describe 'visible_to' do
    describe 'nil user' do
      it 'is true to public texts if public elements of public campaigns' do
        expect(content_text.visible_to).to eq(true)
      end

      it 'is false to public texts of public elements of private campaigns' do
        campaign.update(is_public: false)

        expect(content_text.visible_to).to eq(false)
      end

      it 'is false to public texts of private elements' do
        element.update(visibility: :for_all_players)

        expect(content_text.visible_to).to eq(false)
      end
    end

    describe 'player' do
      before do
        campaign.players << player
      end

      it 'is true for players' do
        content_text.update(visibility: :for_all_players)

        expect(content_text.visible_to(player)).to eq(true)
      end

      it 'is true for some' do
        content_text.update(visibility: :for_some)

        expect(content_text.visible_to(player)).to eq(false)

        content_text.players_visible_for << player

        expect(content_text.visible_to(player)).to eq(true)
      end

      it 'is false for elements children of author elements' do
        element.update(visibility: :author_only)

        expect(content_text.visible_to(player)).to eq(false)
      end
    end

    it 'is allways true to the owner of the campaign' do
      author = campaign.user
      element.update(visibility: :author_only)
      content_text.update(visibility: :author_only)

      expect(content_text.visible_to(author)).to eq(true)
    end
  end
end
