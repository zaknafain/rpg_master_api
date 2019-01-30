# frozen_string_literal: true

class Campaign < ApplicationRecord
  attr_accessor :email

  belongs_to :user
  has_many :campaigns_users

  has_many :players, through: :campaigns_users, source: :user,
                     dependent: :destroy

  has_many :hierarchy_elements, as: :hierarchable, dependent: :destroy

  validates :name, :description, presence: true
  validates :short_description, length: { maximum: 1000 }
  validates :is_public, inclusion: { in: [true, false] }

  scope :are_public, -> { where is_public: true }
  scope :all_campaigns_for, lambda(user_id) do
    where('campaigns.user_id = ? OR campaigns.id IN (?)',
          user_id,
          CampaignsUser.select(:campaign_id).where(user_id: user_id))
  end

  def visible_to(user = nil)
    is_public? ||
      players.include?(user) ||
      self.user == user
  end
end
