require 'rails_helper'

describe User, type: :model do
  let(:user)              { FactoryBot.build(:user, name: "Example User",
                                                     email: "user@example.com",
                                                     password: "foobar Z",
                                                     password_confirmation: "foobar Z") }
  let(:valid_addresses)   { %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn) }
  let(:invalid_addresses) { %w(user@foo,com user_at_foo.org example.user@foo.
                               foo@bar_baz.com foo@bar+baz.com) }
  let(:campaign)          { FactoryBot.create(:campaign, user: user) }
  let(:played_campaign)   { FactoryBot.create(:campaign, players: [user]) }

  subject { user }

  describe "validations" do
    describe "email" do
      it "is invalid" do
        invalid_addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).to_not be_valid
        end
      end

      it "is valid" do
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    describe "password and password_confirmation" do
      it "is not valid when too short" do
        user.password = user.password_confirmation = "a" * 5

        expect(user).to_not be_valid
      end

      it "is not valid when they are not the same" do
        user.password_confirmation = "mismatch"

        expect(user).to_not be_valid
      end

      it "is valid on a persisted user when password is empty" do
        user.save

        expect(user).to be_valid
      end
    end
  end

  it "remember token will get created on save" do
    user.save!

    expect(user.remember_token).to_not be_blank
  end

  describe "destroy" do
    let(:element) { FactoryBot.create(:hierarchy_element, hierarchable: played_campaign, visibility: :for_some) }

    it "will remove all associations as player" do
      played_campaign

      expect { user.destroy }.to change { CampaignsUser.count }.by(-1)
    end

    it "will destroy all owned campaigns of this user" do
      campaign

      expect { user.destroy }.to change { Campaign.count }.by(-1)
    end

    it "will destroy all hierarchy_elements_users" do
      element.players_visible_for << user

      expect { user.destroy }.to change { HierarchyElementsUser.count }.by(-1)
    end

    it "will destroy all content_texts_users" do
      content = FactoryBot.create(:content_text, hierarchy_element: element)
      content.players_visible_for << user

      expect { user.destroy }.to change { ContentTextsUser.count }.by(-1)
    end
  end

  describe "methods" do
    describe "players" do
      it "will return [] when the user has no campaigns" do
        expect(user.players).to eq([])
      end

      it "will return all current players of the campaigns of the user" do
        campaign
        player = FactoryBot.create(:user)
        campaign.players << player

        expect(user.players).to eq([player])
      end
    end
  end
end
